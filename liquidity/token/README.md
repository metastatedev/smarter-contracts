The majority of this token standard is adopted from [here](https://github.com/OCamlPro/liquidity/blob/next/tests/others/token.liq).  A comparable Ethereum standard can be found [here](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

# Start a token system

To start a token system, one first has to originate the token contract on the Tezos network.  Then, accounts can be created and endowed with tokens.

## Deploy the token contract

To originate a token system, run: 

```tezos-client originate contract [name of the token contract] for [manager of the token contract] transferring [amount to transfer from source] from [address that pays for the origination] running [the token script in .tz] --init [the initial storage]``` 

The token script has a storage initializer that initializes the initial storage.  The inputs to pass to the initializer include:

- **owner** (owner of the token system, only this owner can create accounts /mint tokens, of type (KT1/tz1) *address*): 
e.g., tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
- **totalSupply** (total supply of this type of tokens, of type *nat*): e.g., 500p
- **name** (the name of the token, of type *string*): e.g., "TokenA" or "TokenB" 
- **symbol** (symbol representation of the token, of type *string*): e.g.,"A" or "B" 

The initial storage has the following fields:
~~~~
{ 
  accounts = BigMap; 
  version = 1p; 
  totalSupply = 500p; 
  name = "TokenB"; 
  symbol = "B"; 
  owner = (tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS : address) 
} 
~~~~
After the deployment, the "accounts" field is an empty *BigMap*.  The owner (in this example,tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS) can add accounts and transfer tokens into these accounts. 

## Create accounts


