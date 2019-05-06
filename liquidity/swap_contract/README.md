# Swapping fungible tokens on Tezos:

This contract facilitates **token swaps between two parties**.  Imagine a market place with asks and bids of two types of fungible tokens.  Once an ask offer is accepted, this contract can perform the transaction.  The parties do not need to know or trust each other once an agreement for the swap is reached.

The swap contract builds on tokens that are initiated with the [token contract](https://github.com/cryptiumlabs/smarter-contracts/tree/master/liquidity/token), and calls the *transferFrom* entry point of that contract.  The swap contract checks that 

- the parties agree to the swapping amounts.
- the parties have approve the agreed amounts and have enough balance for the agreed amounts.

Once verified, the transfers of the two tokens are called.  **Unless there are other errors**, the transfers should both succeed. 

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

## An example contract call

Here I provide an example on how the swap contract can be called.  In this example, **Adam agrees to give Bob 30 Token A to get 60 Token B from Bob**.

For reference, here is Bob's balance of Token A before Adam transfers him 30:

```tezos-client get big map value for '"tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6"' of type address in KT1Gu5MXA5RpXo2veYc7n33QVmH1rdTVZhum```

Bob has 100 Token A before the transfer:
~~~~
Pair 100 {}
~~~~

Adam's balance of Token B before Bob transfers him 60:

```tezos-client get big map value for '"tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD"' of type address in KT19yAMFum5MmD99kusQiCBGpTEVC1B52f9Q```

Adam has 200 Token B before the transfer:
~~~~
Pair 200 {}
~~~~

Conditions for the swap contract call to be successful:

**C1**. Adam (tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD) has to have at least 30 Token A in the Token A system (KT1Gu5MXA5RpXo2veYc7n33QVmH1rdTVZhum). 
**C2**. Adam has to have approved at least 30 Token A to Bob (tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6). 
**C3**. Bob has to have at least 60 Token B in the Token B system (KT19yAMFum5MmD99kusQiCBGpTEVC1B52f9Q). 
**C4**. Bob has to have approved at least 60 Token A to Adam. 

To check C1 and C2, one can run the following command on the Tezos CLI:

```tezos-client get big map value for '"tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD"' of type address in KT1Gu5MXA5RpXo2veYc7n33QVmH1rdTVZhum```

The output shows that Adam has a balance of 200 Token A and he has set the allowance to Bob to be 30:

~~~~
Pair 200 { Elt 0x000041145574571df6030acad578fdc8d41c4979f0df 30 }
~~~~

To check C3 and C3, run:

```tezos-client get big map value for '"tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6"' of type address in KT19yAMFum5MmD99kusQiCBGpTEVC1B52f9Q```

The output shows that Bob has a balance of 200 Token B and he has set the allowance to Adam to be 60:
~~~~
Pair 200 { Elt 0x0000d8aebdc7e7d86e00d26b5f9c038dd87b01631ba6 60 }
~~~~



