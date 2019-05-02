# Swapping fungible tokens on Tezos:

see if you can write a simple swap contract which uses transferFrom
e.g. users Alice and Bob want to swap 5 tokenA for 10 tokenB
and they don't trust each other
so they both approve a swap contract, which calls transferFrom appropriately to atomically swap their tokens in one transaction

## Contract Overview:

To execute a swap the following contract must be originated in Tezos:
- The token contracts (e.g., Token A and Token B)
- The swap contract, it can swap any two types of tokens and any two Tezos addresses.

### Token contracts:

The token systems of the tokens to be swapped must already be in place.  The token systems' contract addresses will be passed to the swap contract as inputs.

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


The Swap contract:
 
The swap contractStorage: 
Parameters: 
token a transfer amount, 
token b transfer amount,
token a transfer from address (it’s also the token b transfer to address), 
token b transfer from address (it’s also the token a transfer to address),
contract instance of token A, 
contract instance of token B.

Will use:  
Contract.call: dest:'S.instance -> amount:tez -> ?entry:<entry_name> parameter:'a -> operation. Forge an internal contract call. It is translated to TRANSFER_TOKENS in Michelson. Arguments can be labeled, in which case they can be given in any order. The entry point name is optional (main by default). Or
<c.entry>: 'parameter -> amount:tez -> operation. Forge an internal contract call. It is translated to TRANSFER_TOKENS in Michelson. The amount argument can be labeled, in which case it can appear before the parameter.

The swap contract calls the transfers only if both parties approve i.e., allowances are the appropriate transfer amounts:

the token A contract’s transferFrom entry point, transferring token A from Alice to Bob = opa
The token B contract’s transferFrom entry point, transferring token B from Bob to Alice = opb
The contract returns [opa;opb],()

Problem: 
how does one check that the allowances are the appropriate amounts?  The allowance entry’s output is an operation that calls another contract with the allowance as the parameter.
How does one make sure both transfers succeed or fail together?  
One needs to check that all conditions that may cause the transfer to fail
A function that simulates the transfer, and checks if it fails will be helpful (No such function was found.)
If such a function does not exist, need to check (THIS MAY NOT BE THE COMPLETE LIST!  NEED TO WARN USERS):
Balance >= allowance (if balance is smaller than allowance transfer will fail even if the allowance is the agreed amount
Allowance >= agreed amount
Turn storage to be (allowances, account balance)
Add an entry point in the swap contract that updates the storage with the input parameters.  Make the first op to be calling the token contract’s allowance entry point, which returns an op that calls a contract with the parameters (allowances, account balance) of an account.  So:
Op1 = ???
Op2 = if (storage.balance >= allowance) & (storage.allowance >= transfer amount) for BOTH tokens so 4 conditions total!
then [contract call for transfer of token a]
Else failwith “Transfer failed” 
Then op3 = [contract call for transfer of token b] because it’s a list of sequential ops, should not fire when failwith is fired.
                
Use an escrow: each party transfer their tokens to the escrow first, then if the escrow has the correct amounts for both tokens, the op list can fire, otherwise, fire failwith “Transfer failed.” (Doesn’t work, because it causes the same problem of having to check the balance of the escrow account!)



