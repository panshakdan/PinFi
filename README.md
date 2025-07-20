# PinFi Smart Contract

PinFi is a Clarity smart contract for Stacks that implements a non-fungible token (NFT) access and rewards system. It allows the contract owner to mint unique "PinFi Pass" NFTs, assign access levels, manage transferability, and distribute rewards to holders. Users can transfer, burn, and claim rewards based on their NFT ownership.

---

## Features

- **NFT Minting:** Owner can mint unique PinFi Pass NFTs for users.
- **Access Levels:** Each NFT can have an assigned access level.
- **Transfer Control:** Owner can enable/disable transfer for each NFT.
- **Rewards System:** Owner can distribute rewards to NFT holders; holders can claim rewards.
- **Batch Rewards:** Owner can distribute rewards to up to 10 holders at once.
- **Ownership Management:** Owner can transfer contract ownership.
- **Pause/Unpause:** Owner can pause or unpause contract actions.
- **Burn:** NFT holders can burn their tokens.
- **Emergency Withdraw:** Owner can withdraw contract funds in emergencies.

---

## Contract Functions

### Read-Only

- `get-contract-owner`: Returns the contract owner.
- `get-next-id`: Returns the next NFT token ID.
- `is-contract-paused`: Checks if the contract is paused.
- `get-token-uri <token-id>`: Gets the metadata URI for a token.
- `get-access-level <token-id>`: Gets the access level for a token.
- `get-holder-rewards <holder>`: Gets the reward balance for a holder.
- `is-transfer-enabled <token-id>`: Checks if a token is transferable.
- `has-pinfi-access <user>`: Checks if a user owns any of the first 20 PinFi Pass NFTs.
- `get-user-pinfi-count <user>`: Counts how many PinFi Pass NFTs a user owns (first 20).
- `get-user-first-pinfi <user>`: Gets the first PinFi Pass NFT owned by a user.
- `get-contract-balance`: Returns the contract's STX balance.

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

## Usage

1. **Deploy the contract** to the Stacks blockchain.
2. **Mint NFTs** for users using `mint-pinfi-pass`.
3. **Assign metadata and access levels** with `set-token-uri` and `set-access-level`.
4. **Distribute rewards** to holders using `distribute-rewards` or `batch-distribute-rewards`.
5. **Users can claim rewards** with `claim-rewards` and transfer/burn their NFTs as allowed.

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

## License

This project is provided for educational and demonstration purposes. Please review and audit before deploying to mainnet.

---

## Author

PinFi Smart Contract by [panshak danladi]
