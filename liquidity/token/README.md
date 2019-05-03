This token standard is adopted from [here](https://github.com/OCamlPro/liquidity/blob/next/tests/others/token.liq).  A comparable Ethereum standard can be found [here](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

To originate a token system, run: 

```tezos-client originate contract [name of the token contract] for [manager of the token contract] transferring [amount to transfer from source] from [address that pays for the origination] running [the token script in .tz] --init [the initial storage]``` 

The token script has a storage initializer that initializes the initial storage.  The inputs to pass to the initializer include:

- **owner** (owner of the token system, only this owner can create accounts /mint tokens, of type (KT1/tz1) *address*): 
e.g., tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
- **totalSupply** (total supply of this type of tokens, of type *nat*): e.g., 500p
- **Decimals** (the number of decimals the token uses - e.g. 4, means to divide the token amount by 10000 to get its user representation, of type *nat*): 
e.g., 0p
- **name** (the name of the token, of type *string*): e.g., "TokenA" or "TokenB" 
- **symbol** (symbol representation of the token, of type *string*): e.g.,"A" or "B" 


