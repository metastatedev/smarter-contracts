### Concepts

#### Basic

##### Fungible Token

Implement a transferable fungible token.

Interface functions:
- Retrieve total supply
- Retrieve account balance for a key
- Mint tokens (permissioned to an owner)
- Transfer tokens from the sender to another key
- Permanently burn the sender's tokens

##### Non-fungible Token

Implement a transferable non-fungible token.

Interface functions:
- Retrieve list of all tokens
- Retrieve owner of a particular token
- Retrieve tokens owned by a particular key
- Mint a new token (permissioned to an owner)
- Transfer a particular token from the sender to another key
- Permanently destroy a particular token

#### Intermediate

##### Atomic Token Swap (DEX)

Implement a simple decentralized exchange to swap specified amounts of fungible tokens with off-chain signed orders.

Interface functions:
- Deposit tokens
- Withdraw tokens
- Inspect token balances for a particular user & token
- Validate order
- Check order signature
- Execute order match and transfer tokens

##### Weighted Multisignature

Implement a numerical-threshold weighted-key multisignature contract (a bit like a shareholder-association DAO).

Interface functions:
- Inspect keys, weights, current threshold
- Add a new key, specifying weight
- Remove a key
- Change required threshold to send a transaction
- Sign a transaction (must provide signatures from enough keys)

#### Advanced

##### Prediction Market

##### LR Funding Dispensary
