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

;; ===== NFT DEFINITION =====
(define-non-fungible-token pinfi-pass uint)

;; ===== DATA MAPS =====
(define-map token-uri uint (string-ascii 256))
(define-map holder-rewards principal uint)
(define-map transfer-enabled uint bool)
(define-map access-levels uint uint)

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

;; ===== READ-ONLY FUNCTIONS =====
(define-read-only (get-contract-owner)
    (var-get contract-owner))

(define-read-only (get-next-id)
    (var-get next-id))

(define-read-only (is-contract-paused)
    (var-get contract-paused))

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

;; Fixed has-access function - pure read-only implementation
(define-read-only (has-pinfi-access (user principal))
    (let ((max-id (var-get next-id)))
        (if (is-eq max-id u1)
            false
            (or (and (>= max-id u1) (is-token-owner u1 user))
                (and (>= max-id u2) (is-token-owner u2 user))
                (and (>= max-id u3) (is-token-owner u3 user))
                (and (>= max-id u4) (is-token-owner u4 user))
                (and (>= max-id u5) (is-token-owner u5 user))
                (and (>= max-id u6) (is-token-owner u6 user))
                (and (>= max-id u7) (is-token-owner u7 user))
                (and (>= max-id u8) (is-token-owner u8 user))
                (and (>= max-id u9) (is-token-owner u9 user))
                (and (>= max-id u10) (is-token-owner u10 user))
                (and (>= max-id u11) (is-token-owner u11 user))
                (and (>= max-id u12) (is-token-owner u12 user))
                (and (>= max-id u13) (is-token-owner u13 user))
                (and (>= max-id u14) (is-token-owner u14 user))
                (and (>= max-id u15) (is-token-owner u15 user))
                (and (>= max-id u16) (is-token-owner u16 user))
                (and (>= max-id u17) (is-token-owner u17 user))
                (and (>= max-id u18) (is-token-owner u18 user))
                (and (>= max-id u19) (is-token-owner u19 user))
                (and (>= max-id u20) (is-token-owner u20 user))))))

;; Count user tokens - pure read-only
(define-read-only (get-user-pinfi-count (user principal))
    (let ((max-id (var-get next-id)))
        (if (is-eq max-id u1)
            u0
            (+ (if (and (>= max-id u1) (is-token-owner u1 user)) u1 u0)
               (if (and (>= max-id u2) (is-token-owner u2 user)) u1 u0)
               (if (and (>= max-id u3) (is-token-owner u3 user)) u1 u0)
               (if (and (>= max-id u4) (is-token-owner u4 user)) u1 u0)
               (if (and (>= max-id u5) (is-token-owner u5 user)) u1 u0)
               (if (and (>= max-id u6) (is-token-owner u6 user)) u1 u0)
               (if (and (>= max-id u7) (is-token-owner u7 user)) u1 u0)
               (if (and (>= max-id u8) (is-token-owner u8 user)) u1 u0)
               (if (and (>= max-id u9) (is-token-owner u9 user)) u1 u0)
               (if (and (>= max-id u10) (is-token-owner u10 user)) u1 u0)
               (if (and (>= max-id u11) (is-token-owner u11 user)) u1 u0)
               (if (and (>= max-id u12) (is-token-owner u12 user)) u1 u0)
               (if (and (>= max-id u13) (is-token-owner u13 user)) u1 u0)
               (if (and (>= max-id u14) (is-token-owner u14 user)) u1 u0)
               (if (and (>= max-id u15) (is-token-owner u15 user)) u1 u0)
               (if (and (>= max-id u16) (is-token-owner u16 user)) u1 u0)
               (if (and (>= max-id u17) (is-token-owner u17 user)) u1 u0)
               (if (and (>= max-id u18) (is-token-owner u18 user)) u1 u0)
               (if (and (>= max-id u19) (is-token-owner u19 user)) u1 u0)
               (if (and (>= max-id u20) (is-token-owner u20 user)) u1 u0)))))

;; Get first token owned by user - pure read-only
(define-read-only (get-user-first-pinfi (user principal))
    (let ((max-id (var-get next-id)))
        (if (is-eq max-id u1)
            none
            (if (and (>= max-id u1) (is-token-owner u1 user)) (some u1)
            (if (and (>= max-id u2) (is-token-owner u2 user)) (some u2)
            (if (and (>= max-id u3) (is-token-owner u3 user)) (some u3)
            (if (and (>= max-id u4) (is-token-owner u4 user)) (some u4)
            (if (and (>= max-id u5) (is-token-owner u5 user)) (some u5)
            (if (and (>= max-id u6) (is-token-owner u6 user)) (some u6)
            (if (and (>= max-id u7) (is-token-owner u7 user)) (some u7)
            (if (and (>= max-id u8) (is-token-owner u8 user)) (some u8)
            (if (and (>= max-id u9) (is-token-owner u9 user)) (some u9)
            (if (and (>= max-id u10) (is-token-owner u10 user)) (some u10)
            (if (and (>= max-id u11) (is-token-owner u11 user)) (some u11)
            (if (and (>= max-id u12) (is-token-owner u12 user)) (some u12)
            (if (and (>= max-id u13) (is-token-owner u13 user)) (some u13)
            (if (and (>= max-id u14) (is-token-owner u14 user)) (some u14)
            (if (and (>= max-id u15) (is-token-owner u15 user)) (some u15)
            (if (and (>= max-id u16) (is-token-owner u16 user)) (some u16)
            (if (and (>= max-id u17) (is-token-owner u17 user)) (some u17)
            (if (and (>= max-id u18) (is-token-owner u18 user)) (some u18)
            (if (and (>= max-id u19) (is-token-owner u19 user)) (some u19)
            (if (and (>= max-id u20) (is-token-owner u20 user)) (some u20)
            none)))))))))))))))))))))))

;; ===== ADMIN FUNCTIONS =====
(define-public (transfer-ownership (new-owner principal))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-principal new-owner) ERR-INVALID-PRINCIPAL)
        (asserts! (not (is-eq new-owner (var-get contract-owner))) ERR-INVALID-PRINCIPAL)
        (ok (var-set contract-owner new-owner))))

(define-public (pause-contract)
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (ok (var-set contract-paused true))))

(define-public (unpause-contract)
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (ok (var-set contract-paused false))))

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
                (ok id)))))

(define-public (set-token-uri (token-id uint) (uri (string-ascii 256)))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-valid-uri uri) ERR-INVALID-URI)
        (ok (map-set token-uri token-id uri))))

(define-public (set-access-level (token-id uint) (level uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-valid-level level) ERR-INVALID-LEVEL)
        (ok (map-set access-levels token-id level))))

(define-public (set-transfer-status (token-id uint) (enabled bool))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (ok (map-set transfer-enabled token-id enabled))))

;; Fixed transfer function with proper ownership verification
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
        (ok true)))

;; ===== REWARD SYSTEM =====
;; Fixed distribute-rewards with direct access verification
(define-public (distribute-rewards (holder principal) (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (asserts! (is-valid-principal holder) ERR-INVALID-PRINCIPAL)
        ;; Direct access check without circular dependency
        (asserts! (is-some (get-user-first-pinfi holder)) ERR-NO-ACCESS)
        (ok (map-set holder-rewards holder 
            (+ (default-to u0 (map-get? holder-rewards holder)) amount)))))

;; Fixed claim-rewards with direct access verification
(define-public (claim-rewards (amount uint))
    (begin
        (asserts! (not (var-get contract-paused)) ERR-NOT-AUTHORIZED)
        ;; Direct access check without circular dependency
        (asserts! (is-some (get-user-first-pinfi tx-sender)) ERR-NO-ACCESS)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (let ((current-balance (default-to u0 (map-get? holder-rewards tx-sender))))
            (asserts! (>= current-balance amount) ERR-INSUFFICIENT-BALANCE)
            (try! (stx-transfer? amount (as-contract tx-sender) tx-sender))
            (map-set holder-rewards tx-sender (- current-balance amount))
            (ok true))))

;; Batch reward distribution - removed circular dependency
(define-public (batch-distribute-rewards (holders (list 10 principal)) (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (ok (map distribute-reward-to-holder holders))))

;; Helper function without circular dependency
(define-private (distribute-reward-to-holder (holder principal))
    (if (is-some (get-user-first-pinfi holder))
        (map-set holder-rewards holder 
            (+ (default-to u0 (map-get? holder-rewards holder)) u1))
        false))

;; Emergency functions
(define-public (emergency-withdraw (amount uint))
    (begin
        (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
        (asserts! (is-valid-amount amount) ERR-INVALID-AMOUNT)
        (try! (stx-transfer? amount (as-contract tx-sender) (var-get contract-owner)))
        (ok true)))

;; Utility function to check contract balance
(define-read-only (get-contract-balance)
    (stx-get-balance (as-contract tx-sender)))

;; Burn function for completeness
(define-public (burn (token-id uint))
    (begin
        (asserts! (is-valid-token-id token-id) ERR-INVALID-TOKEN-ID)
        (asserts! (token-exists token-id) ERR-TOKEN-NOT-FOUND)
        (asserts! (is-token-owner token-id tx-sender) ERR-NOT-TOKEN-OWNER)
        (try! (nft-burn? pinfi-pass token-id tx-sender))
        (ok true)))