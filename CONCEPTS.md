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

##### Multisignature

Implement a numerical-threshold weighted-key multisignature contract.

Interface functions:
- Inspect keys, weights, current threshold
- Add a new key, specifying weight
- Remove a key
- Change required threshold to send a transaction
- Sign a transaction (must provide signatures from enough keys)

#### Intermediate

##### Atomic Token Swap (DEX)

##### Shareholder Association DAO

#### Advanced

##### Prediction Market

##### LR Funding Dispensary
