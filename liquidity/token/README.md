The majority of this token standard is adopted from [here](https://github.com/OCamlPro/liquidity/blob/next/tests/others/token.liq).  A comparable Ethereum standard can be found [here](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

# Start a token system

To start a token system, one first has to originate the token contract on the Tezos network.  Then, accounts can be created and endowed with tokens.

## Deploy the token contract

To originate a token system using the tezos-client, run: 

```tezos-client originate contract [name of the token contract] for [manager of the token contract] transferring [amount to transfer from source] from [address that pays for the origination] running [the token script in .tz] --init [the initial storage]``` 

Alternatively, one can originate the contract using [Liquidity](http://www.liquidity-lang.org/doc/usage/index.html#running-a-simulation-of-the-contract) or the [Liquidity online editor](http://www.liquidity-lang.org/edit/).

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
After the deployment, the "accounts" field is an empty *BigMap*.  The owner (in this example,tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS) can add accounts and transfer tokens into these accounts with the *createAccount* or *createAccounts* entry points. 

## Create account(s)

To create an account, choose the entry point *createAccount* with the parameters:

- the address of the owner
- the amount of tokens this address owns

To create mulitple accounts, choose the entry point *createAccounts*, and the parameter is a list of pairs of (address, [amount of tokens]).

After the accounts are created, the big map of accounts is updated with the new accounts and their balances.  The accounts also has a map of *allowance* associated with each address (see next section), describing the amounts allowed to other account holders from the associated account holder.

To check that the accounts are created, one can use the Tezos CLI.  To check that an account with 200 token A was created for Adam of address tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6, run:

```tezos-client get big map value for '"tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD"' of type address in KT1Gu5MXA5RpXo2veYc7n33QVmH1rdTVZhum```

The output is a pair of *balance* of type *nat* and *allowance* of type *map*.  Adam has a balance of 200 tokens.  No allowance was set for him, so the value of *allowance* is an empty map:

~~~~
Pair 200 {}
~~~~

Bob of address tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6 has no account and the ouput shows an error: 
````tezos-client get big map value for '"tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6"' of type address in KT1Gu5MXA5RpXo2veYc7n33QVmH1rdTVZhum````

~~~~
Fatal error:
  No value associated to this key.
~~~~

## Transfer tokens

The *transfer* entry point lets an account holder transfer tokens to an address.  The parameter input to this entry point is an *(address, nat) pair*, describing the recipient address and the tokens to be transferred. 

## Set allowance (approve)

The *approve* entry point lets an account holder set an amount of tokens that contracts can transfer on the account holder's behalf.  *allowance* is of type *(address, nat) map*.  Each map entry describes an allowance amount to a recipient address.

After the allowance is set, other contracts can call the *transferFrom* entry point and perform a transfer from the account holder to the specified recipient, up to the allowance amount.  Once a *transferFrom* is performed, the allowance amount is updated.  



