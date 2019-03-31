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

A comparable Ethereum standard can be found [here](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

##### Non-fungible Token

Implement a transferable non-fungible token.

Interface functions:
- Retrieve list of all tokens
- Retrieve owner of a particular token
- Retrieve tokens owned by a particular key
- Mint a new token (permissioned to an owner)
- Transfer a particular token from the sender to another key
- Permanently destroy a particular token

A comparable Ethereum standard can be found [here](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md).

#### Intermediate

##### Order-based DEX

Implement a simple decentralized exchange to swap specified amounts of fungible tokens with off-chain signed orders.

Interface functions:
- Deposit tokens
- Withdraw tokens
- Inspect token balances for a particular user & token
- Validate order
- Check order signature
- Execute order match and transfer tokens

A simple Ethereum implementation can be found [here](https://github.com/etherdelta/smart_contract). A more complex Ethereum implementation can be found [here](https://github.com/wyvernprotocol/wyvern-v3).

##### Floating-rate DEX

Implement an escrow-based floating-rate decentralized exchange roughly as described in [the Uniswap whitepaper](https://hackmd.io/s/HJ9jLsfTz).

##### Weighted Multisignature

Implement a numerical-threshold weighted-key multisignature contract (a bit like a shareholder-association DAO).

Interface functions:
- Inspect keys, weights, current threshold
- Add a new key, specifying weight
- Remove a key
- Change required threshold to send a transaction
- Sign a transaction (must provide signatures from enough keys)

A comparable Ethereum implementation can be found [here](https://github.com/ProjectWyvern/wyvern-ethereum/blob/master/contracts/dao/DelegatedShareholderAssociation.sol).

#### Advanced

##### Prediction Market

Implement a tokenized prediction market based roughly on the model described in [this paper](https://www.truthcoin.info/papers/truthcoin-whitepaper.pdf).

A description of a comparable Ethereum implementation can be found [here](https://www.augur.net/whitepaper.pdf).

##### LR Funding Dispensary

Implement a smart contract to match donated funds to public goods projects according to the equations in [this paper](https://arxiv.org/pdf/1809.06421.pdf).
