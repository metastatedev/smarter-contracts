# Swapping fungible tokens on Tezos:

This contract facilitates swapping of tokens between two parties.  It checks that 

- the parties agree to the swapping amounts.
- the parties have approve the agreed amounts and have enough balance for the agreed amounts.

Once verified, the transfers of the tokens are called.  Unless there are other error, the transfers should both succeed. 

This contract builds on tokens that are initiated with the [token contract](https://github.com/cryptiumlabs/smarter-contracts/tree/master/liquidity/token), and calls the *transferFrom* entry point of that contract.

## Contract Overview:

To execute a swap the following contract must be originated in Tezos:
- The token contracts (e.g., Token A and Token B)
- The swap contract, it can swap any two types of tokens and any two Tezos addresses.

### Token contracts:

The token systems of the tokens to be swapped must already be in place.  The token systems' contract addresses will be passed to the swap contract as inputs.  See [this](https://github.com/cryptiumlabs/smarter-contracts/blob/master/liquidity/token/README.md) for more information on the token contract.

### The Swap contract:
 
The swap contract storage contains the following information:
- addresses of the token contracts/systems.  E.g., token A (KT1D7UF5Yqtn7QyqH6ty9Sw62oZaUgcZHNXL) and token B (KT1TdDXW1AjDrekZmUSuy98HwhRBXmD3znwg).
- addresses of the two parties that are involved in the swap. E.g., Alice (tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS) and Bob (tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6).
- the agreed swap amounts. E.g., Alice gives 5 token A to Bob and gets 10 token B from Bob.
Storage: 
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

Problems: 
How to have both party agree to the amount and ratio?  one person is the originator of the swap contract, the other (the launcher) review the storage of the originated contract, then call it.  The originator has to input the agreed transfer amounts and the addresses of the originator and the launcher.  Only the launcher (as input in the storage) can call the contract, after verifying the content in the storage regarding the exchange amounts.

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



