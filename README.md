# PinFi Smart Contract

PinFi is a Clarity smart contract for the Stacks blockchain that implements an NFT-based access and rewards system. It features advanced event logging, optimized token management, and robust administrative controls. The contract allows the owner to mint unique "PinFi Pass" NFTs, assign access levels, manage transferability, and distribute rewards to holders.

---

## Features

- **NFT Minting:** Owner can mint unique PinFi Pass NFTs for users.
- **Access Levels:** Assign and manage access levels per token.
- **Transfer Control:** Enable or disable transferability for each token.
- **Rewards System:** Distribute and claim rewards tied to NFT ownership.
- **Batch Rewards:** Distribute rewards to up to 10 holders at once.
- **Event Logging:** All major operations emit detailed events with nonce, block height, and sender.
- **Admin Controls:** Transfer contract ownership, pause/unpause contract, emergency withdrawal.
- **Token Operations:** Transfer, burn, and manage tokens.
- **Utility Functions:** Get user info and contract stats in a single call.

---

## Contract Functions

### Read-Only

- `get-contract-owner`: Returns the contract owner.
- `get-next-id`: Returns the next NFT token ID.
- `is-contract-paused`: Checks if the contract is paused.
- `get-event-nonce`: Returns the current event nonce.
- `get-token-uri <token-id>`: Gets the metadata URI for a token.
- `get-access-level <token-id>`: Gets the access level for a token.
- `get-holder-rewards <holder>`: Gets the reward balance for a holder.
- `is-transfer-enabled <token-id>`: Checks if a token is transferable.
- `has-pinfi-access <user>`: Checks if a user owns any of the first 20 PinFi Pass NFTs.
- `get-user-pinfi-count <user>`: Counts how many PinFi Pass NFTs a user owns (first 20).
- `get-user-first-pinfi <user>`: Gets the first PinFi Pass NFT owned by a user.
- `get-contract-balance`: Returns the contract's STX balance.
- `get-user-info <user>`: Returns comprehensive user data (access, token count, first token, rewards).
- `get-contract-stats`: Returns contract-wide statistics and status.

### Public

- `transfer-ownership <new-owner>`: Transfer contract ownership.
- `pause-contract`: Pause contract actions.
- `unpause-contract`: Unpause contract actions.
- `mint-pinfi-pass <recipient>`: Mint a new PinFi Pass NFT.
- `set-token-uri <token-id> <uri>`: Set metadata URI for a token.
- `set-access-level <token-id> <level>`: Set access level for a token.
- `set-transfer-status <token-id> <enabled>`: Enable/disable transfer for a token.
- `transfer <token-id> <sender> <recipient>`: Transfer a token between users.
- `distribute-rewards <holder> <amount>`: Distribute rewards to a holder.
- `batch-distribute-rewards <holders> <amount>`: Distribute rewards to up to 10 holders.
- `claim-rewards <amount>`: Claim rewards as a holder.
- `emergency-withdraw <amount>`: Owner withdraws contract funds.
- `burn <token-id>`: Burn a PinFi Pass NFT.

---

## Event Types

- `MINT`: Token minting
- `URI_SET`: Metadata updates
- `ACCESS_LEVEL_SET`: Access level changes
- `TRANSFER_STATUS_SET`: Transfer permission updates
- `TRANSFER`: Token transfers
- `REWARD_DISTRIBUTED`: Reward distribution
- `REWARD_CLAIMED`: Reward claims
- `BATCH_REWARD_START`: Batch reward operations
- `EMERGENCY_WITHDRAW`: Emergency withdrawals
- `BURN`: Token burning
- `OWNERSHIP_TRANSFERRED`: Owner changes
- `CONTRACT_PAUSED` / `CONTRACT_UNPAUSED`: State changes

---

## Error Codes

- `u100`: Not authorized
- `u101`: Invalid token ID
- `u102`: Invalid amount
- `u103`: Invalid URI
- `u104`: Invalid principal
- `u105`: Transfer disabled
- `u106`: Not token owner
- `u107`: Insufficient balance
- `u108`: Invalid level
- `u109`: No access
- `u110`: Token not found

---

## Technical Highlights

- **Event Logging:** Every major action emits a structured event for transparency and traceability.
- **Optimized Iteration:** Uses fixed token lists for efficient access checks and counting.
- **Security:** Extensive validation and error handling for all operations.
- **Gas Efficiency:** Optimized fold operations and batch processing.
- **Comprehensive Utility:** Functions for both user and contract-wide insights.

---

## Usage

1. **Deploy the contract** to the Stacks blockchain.
2. **Mint NFTs** for users using `mint-pinfi-pass`.
3. **Assign metadata and access levels** with `set-token-uri` and `set-access-level`.
4. **Distribute rewards** to holders using `distribute-rewards` or `batch-distribute-rewards`.
5. **Users can claim rewards** with `claim-rewards` and transfer/burn their NFTs as allowed.

---

## License

This project is provided for educational and demonstration purposes. Please review and audit before deploying to mainnet.

---

## Author

PinFi Smart Contract by [panshak danladi]

[Last updated: August 1, 2025]
