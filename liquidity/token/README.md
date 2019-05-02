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

Token A Storage:
has both alice and bob’s address in it 
Allowances should be zero before approval, after approval allowance is altered to allow transfer from alice to bob 5 tokenA
Owns by alice but can be owned by a third party
{
  accounts =
    (BigMap
       [(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS,
          {
            balance = 100p;
            allowances = (Map [(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS, 0p);(tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6, 0p)])
          }) ;
         (tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6,
           {
             balance = 100p;
            allowances = (Map
[(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS, 0p);(tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6, 0p)])
          })]);
  version = 0p;
  totalSupply = 200p;
  decimals = 0p;
  name = "tokena";
  symbol = "a";
  owner = tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
}
Token B Storage:
 has both alice and bob’s address in it
Allowances should be zero before approval, after approval allowance is altered to allow transfer from Bob to Alice 10 tokenB:
{
  accounts =
    (BigMap
       [(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS,
          {
            balance = 100p;
            allowances = (Map [(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS, 0p);(tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6, 0p)])
          }) ;
         (tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6,
           {
             balance = 100p;
            allowances = (Map
[(tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS, 0p);(tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6, 0p)])
          })]);
  version = 0p;
  totalSupply = 200p;
  decimals = 0p;
  name = "tokenb";
  symbol = "b";
  owner = tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
}

Take note of the contract addresses (KT1), to be passed in the swap contract as parameters.
