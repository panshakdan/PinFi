;; ===== CONSTANTS =====
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-TOKEN-ID (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-INVALID-URI (err u103))
(define-constant ERR-INVALID-PRINCIPAL (err u104))
(define-constant ERR-TRANSFER-DISABLED (err u105))
(define-constant ERR-NOT-TOKEN-OWNER (err u106))
(define-constant ERR-INSUFFICIENT-BALANCE (err u107))
(define-constant ERR-INVALID-LEVEL (err u108))
(define-constant ERR-NO-ACCESS (err u109))
(define-constant ERR-TOKEN-NOT-FOUND (err u110))

;; ===== DATA VARIABLES =====
(define-data-var contract-owner principal tx-sender)
(define-data-var next-id uint u1)
(define-data-var contract-paused bool false)
(define-data-var event-nonce uint u0)

;; ===== NFT DEFINITION =====
(define-non-fungible-token pinfi-pass uint)

;; ===== DATA MAPS =====
(define-map token-uri uint (string-ascii 256))
(define-map holder-rewards principal uint)
(define-map transfer-enabled uint bool)
(define-map access-levels uint uint)

;; ===== EVENT LOGGING SYSTEM =====
(define-private (emit-event (event-type (string-ascii 32)) (token-id uint) (user principal) (amount uint))
    (let ((nonce (var-get event-nonce)))
        (var-set event-nonce (+ nonce u1))
        (print {
            event: event-type,
            token-id: token-id,
            user: user,
            amount: amount,
            nonce: nonce,
            block-height: stacks-block-height,
            tx-sender: tx-sender
        })))

(define-private (emit-simple-event (event-type (string-ascii 32)) (data uint))
    (let ((nonce (var-get event-nonce)))
        (var-set event-nonce (+ nonce u1))
        (print {
            event: event-type,
            data: data,
            nonce: nonce,
            block-height: stacks-block-height,
            tx-sender: tx-sender
        })))

;; ===== PRIVATE HELPER FUNCTIONS =====
(define-private (is-contract-owner)
    (is-eq tx-sender (var-get contract-owner)))

(define-private (is-valid-token-id (token-id uint))
    (and (> token-id u0) (< token-id (var-get next-id))))

(define-private (is-valid-amount (amount uint))
    (> amount u0))

(define-private (is-valid-uri (uri (string-ascii 256)))
    (> (len uri) u0))

(define-private (is-valid-level (level uint))
    (< level u100))

(define-private (is-valid-principal (principal-to-check principal))
    (is-ok (principal-destruct? principal-to-check)))

(define-private (token-exists (token-id uint))
    (is-some (nft-get-owner? pinfi-pass token-id)))

(define-private (is-token-owner (token-id uint) (user principal))
    (match (nft-get-owner? pinfi-pass token-id)
        owner (is-eq owner user)
        false))

;; ===== FIXED DYNAMIC TOKEN ITERATION HELPERS =====
;; Predefined token lists for different ranges
(define-constant TOKEN-LIST-5 (list u1 u2 u3 u4 u5))
(define-constant TOKEN-LIST-10 (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10))
(define-constant TOKEN-LIST-15 (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15))
(define-constant TOKEN-LIST-20 (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15 u16 u17 u18 u19 u20))
(define-constant TOKEN-LIST-25 (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15 u16 u17 u18 u19 u20 u21 u22 u23 u24 u25))
(define-constant TOKEN-LIST-30 (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10 u11 u12 u13 u14 u15 u16 u17 u18 u19 u20 u21 u22 u23 u24 u25 u26 u27 u28 u29 u30))

;; Fixed create-token-range function using simple conditionals
(define-private (create-token-range (max-id uint))
    (if (<= max-id u1) 
        (list)
        (if (<= max-id u5)
            TOKEN-LIST-5
            (if (<= max-id u10)
                TOKEN-LIST-10
                (if (<= max-id u15)
                    TOKEN-LIST-15
                    (if (<= max-id u20)
                        TOKEN-LIST-20
                        (if (<= max-id u25)
                            TOKEN-LIST-25
                            TOKEN-LIST-30)))))))

;; Fold helper for checking ownership
(define-private (check-ownership-fold (token-id uint) (acc {user: principal, found: bool}))
    (if (get found acc)
        acc
        {user: (get user acc), 
         found: (is-token-owner token-id (get user acc))}))

;; Fold helper for counting tokens
(define-private (count-tokens-fold (token-id uint) (acc {user: principal, count: uint}))
    {user: (get user acc),
     count: (+ (get count acc) 
              (if (is-token-owner token-id (get user acc)) u1 u0))})

;; Fold helper for finding first token
(define-private (find-first-token-fold (token-id uint) (acc {user: principal, first-token: (optional uint)}))
    (if (is-some (get first-token acc))
        acc
        {user: (get user acc),
         first-token: (if (is-token-owner token-id (get user acc))
                         (some token-id)
                         none)}))

;; ===== READ-ONLY FUNCTIONS =====
(define-read-only (get-contract-owner)
    (var-get contract-owner))

(define-read-only (get-next-id)
    (var-get next-id))

(define-read-only (is-contract-paused)
    (var-get contract-paused))

(define-read-only (get-event-nonce)
    (var-get event-nonce))

(define-read-only (get-token-uri (token-id uint))
    (begin
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (ok (map-get? token-uri token-id))))

(define-read-only (get-access-level (token-id uint))
    (begin
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (ok (default-to u0 (map-get? access-levels token-id)))))

(define-read-only (get-holder-rewards (holder principal))
    (default-to u0 (map-get? holder-rewards holder)))

(define-read-only (is-transfer-enabled (token-id uint))
    (default-to true (map-get? transfer-enabled token-id)))

;; ===== IMPROVED DYNAMIC ACCESS FUNCTIONS =====
;; Improved has-access function using fold
(define-read-only (has-pinfi-access (user principal))
    (let ((max-id (var-get next-id))
          (token-list (create-token-range max-id)))
        (if (is-eq max-id u1)
            false
            (get found (fold check-ownership-fold token-list {user: user, found: false})))))

;; Improved token count using fold
(define-read-only (get-user-pinfi-count (user principal))
    (let ((max-id (var-get next-id))
          (token-list (create-token-range max-id)))
        (if (is-eq max-id u1)
            u0
            (get count (fold count-tokens-fold token-list {user: user, count: u0})))))

;; Improved first token finder using fold
(define-read-only (get-user-first-pinfi (user principal))
    (let ((max-id (var-get next-id))
          (token-list (create-token-range max-id)))
        (if (is-eq max-id u1)
            none
            (get first-token (fold find-first-token-fold token-list {user: user, first-token: none})))))

;; ===== ADMIN FUNCTIONS =====
(define-public (transfer-ownership (new-owner principal))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-principal new-owner) ERR-INVALID-PRINCIPAL)
        (asserts! (not (is-eq new-owner (var-get contract-owner))) ERR-INVALID-PRINCIPAL)
        (var-set contract-owner new-owner)
        (emit-simple-event "OWNERSHIP_TRANSFERRED" u0)
        (ok true)))

(define-public (pause-contract)
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (var-set contract-paused true)
        (emit-simple-event "CONTRACT_PAUSED" u1)
        (ok true)))

(define-public (unpause-contract)
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (var-set contract-paused false)
        (emit-simple-event "CONTRACT_UNPAUSED" u0)
        (ok true)))

;; ===== NFT FUNCTIONS =====
(define-public (mint-pinfi-pass (recipient principal))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (not (var-get contract-paused)) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-principal recipient) ERR-INVALID-PRINCIPAL)
        (let ((id (var-get next-id)))
            (begin
                (var-set next-id (+ id u1))
                (try! (nft-mint? pinfi-pass id recipient))
                (emit-event "MINT" id recipient u0)
                (ok id)))))

(define-public (set-token-uri (token-id uint) (uri (string-ascii 256)))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-valid-uri uri) ERR-INVALID-URI)
        (map-set token-uri token-id uri)
        (emit-event "URI_SET" token-id tx-sender u0)
        (ok true)))

(define-public (set-access-level (token-id uint) (level uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-valid-level level) ERR-INVALID-LEVEL)
        (map-set access-levels token-id level)
        (emit-event "ACCESS_LEVEL_SET" token-id tx-sender level)
        (ok true)))

(define-public (set-transfer-status (token-id uint) (enabled bool))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (map-set transfer-enabled token-id enabled)
        (emit-event "TRANSFER_STATUS_SET" token-id tx-sender (if enabled u1 u0))
        (ok true)))

;; Enhanced transfer function with event logging
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (not (var-get contract-paused)) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-valid-principal sender) ERR-INVALID-PRINCIPAL)
        (asserts! (is-valid-principal recipient) ERR-INVALID-PRINCIPAL)
        (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
        (asserts! (is-token-owner token-id sender) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-transfer-enabled token-id) ERR-TRANSFER-DISABLED)
        (try! (nft-transfer? pinfi-pass token-id sender recipient))
        (emit-event "TRANSFER" token-id recipient u0)
        (ok true)))

;; ===== REWARD SYSTEM =====
;; Enhanced distribute-rewards with event logging
(define-public (distribute-rewards (holder principal) (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (asserts! (is-valid-principal holder) ERR-INVALID-PRINCIPAL)
        (asserts! (is-some (get-user-first-pinfi holder)) ERR-NO-ACCESS)
        (map-set holder-rewards holder 
            (+ (default-to u0 (map-get? holder-rewards holder)) amount))
        (emit-event "REWARD_DISTRIBUTED" u0 holder amount)
        (ok true)))

;; Enhanced claim-rewards with event logging
(define-public (claim-rewards (amount uint))
    (begin
        (asserts! (not (var-get contract-paused)) ERR-NOT-AUTHORIZED)
        (asserts! (is-some (get-user-first-pinfi tx-sender)) ERR-NO-ACCESS)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (let ((current-balance (default-to u0 (map-get? holder-rewards tx-sender))))
            (asserts! (>= current-balance amount) ERR-INSUFFICIENT-BALANCE)
            (try! (stx-transfer? amount (as-contract tx-sender) tx-sender))
            (map-set holder-rewards tx-sender (- current-balance amount))
            (emit-event "REWARD_CLAIMED" u0 tx-sender amount)
            (ok true))))

;; FIXED: Helper function that takes only holder parameter and uses data-var for amount
(define-data-var batch-amount uint u0)

(define-private (distribute-reward-to-holder (holder principal))
    (let ((amt (var-get batch-amount)))
        (if (and (is-valid-principal holder) (is-some (get-user-first-pinfi holder)))
            (begin
                (map-set holder-rewards holder 
                    (+ (default-to u0 (map-get? holder-rewards holder)) amt))
                (emit-event "REWARD_DISTRIBUTED" u0 holder amt)
                true)
            false)))

;; FIXED: Enhanced batch reward distribution using data-var approach
(define-public (batch-distribute-rewards (holders (list 10 principal)) (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        ;; Calculate total amount needed for all holders
        (let ((total-needed (* amount (len holders))))
            ;; Ensure contract has sufficient balance for total distribution
            (asserts! (>= (stx-get-balance (as-contract tx-sender)) total-needed) ERR-INSUFFICIENT-BALANCE)
            ;; Set the batch amount in data-var
            (var-set batch-amount amount)
            (emit-event "BATCH_REWARD_START" u0 tx-sender amount)
            ;; Use map with single-parameter function
            (ok (map distribute-reward-to-holder holders)))))

;; Enhanced emergency functions with event logging
(define-public (emergency-withdraw (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (try! (stx-transfer? amount (as-contract tx-sender) (var-get contract-owner)))
        (emit-event "EMERGENCY_WITHDRAW" u0 (var-get contract-owner) amount)
        (ok true)))

;; ===== UTILITY FUNCTIONS =====
(define-read-only (get-contract-balance)
    (stx-get-balance (as-contract tx-sender)))

;; Enhanced burn function with event logging
(define-public (burn (token-id uint))
    (begin
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-token-owner token-id tx-sender) ERR-NOT-TOKEN-OWNER)
        (try! (nft-burn? pinfi-pass token-id tx-sender))
        (emit-event "BURN" token-id tx-sender u0)
        (ok true)))

;; ===== ADDITIONAL UTILITY FUNCTIONS =====
;; Get comprehensive user info
(define-read-only (get-user-info (user principal))
    {
        has-access: (has-pinfi-access user),
        token-count: (get-user-pinfi-count user),
        first-token: (get-user-first-pinfi user),
        reward-balance: (get-holder-rewards user)
    })

;; Get contract stats
(define-read-only (get-contract-stats)
    {
        total-tokens: (- (var-get next-id) u1),
        contract-balance: (get-contract-balance),
        is-paused: (var-get contract-paused),
        owner: (var-get contract-owner),
        event-count: (var-get event-nonce)
    })

;; ADDED: Utility function to simulate batch distribution before execution
(define-read-only (simulate-batch-distribution (holders (list 10 principal)) (amount uint))
    (let ((total-needed (* amount (len holders)))
          (current-balance (stx-get-balance (as-contract tx-sender))))
        {
            total-holders: (len holders),
            amount-per-holder: amount,
            total-needed: total-needed,
            contract-balance: current-balance,
            sufficient-funds: (>= current-balance total-needed)
        }))
