# Swapping fungible tokens on Tezos:

This contract facilitates **token swaps between two parties**.  Its use case includes a market place with asks and bids of two types of fungible tokens.  Once an ask/bid offer is accepted, this contract can perform the transaction.  The parties do not need to know or trust each other once an agreement for the swap is reached.

The swap contract builds on tokens that are initiated with the [token contract](https://github.com/cryptiumlabs/smarter-contracts/tree/master/liquidity/token), and calls the *transferFrom* entry point of that contract.  The swap contract ensures that the parties agree to the swapping amounts.

For the transfers to succeed, the parties must have approved the agreed amounts in the respective token systems, and they must have enough balance for the agreed amounts.

Once verified, the transfers of the two tokens are called.  **Unless there are other errors**, the transfers should both succeed. If any of the transfers failed with other errors, none of the transfers would be performed.

## Contract Overview:

To execute a swap the following contract must be originated in Tezos:
- The token contracts (e.g., Token A and Token B)
- The swap contract, it can swap any two types of tokens between any two Tezos addresses.

### Token contracts:

The token systems of the tokens to be swapped must already be in place.  The token systems' contract addresses will be passed to the swap contract as inputs.  See [this](https://github.com/cryptiumlabs/smarter-contracts/blob/master/liquidity/token/README.md) for more information.

### The Swap contract:
 
A swap contract has to be deployed (by anyone, but the offerer can do so without even knowing there is an accepter) with the offered amounts in the storage.  Specifically:
- offered amount by the offerer
- accepted amount that the accepter has to send to the offerer
- the offered token type’s token contract instance
- the accepted token type’s token contract instance  

The offerer, after checking that the storage of a swap contract instance contains the correct offer, has to sign (with his/her private key) a message containing that swap contract instance’s address.  This signature is the accepter’s knowledge.

The accepter has to call the contract with the following two parameters:
- the offerer’s public key, 
- the signature of the offerer signing the swap contract instance.

The contract will only perform the transfers when the signature is correct and was signed by the offerer.  Otherwise, ```failwith``` is fired.

## Implementation flaws

This implementation of the swap contract presents a few flaws that can be eliminated in the next versions:

First, a separate deployed swap contract is required for each set of agreed swap amounts, because the signed message only contains the swap contract instance.  The code can be updated such that the offerer signed a message containing the agreed amounts.  The deployed swap contract storage can be ```unit``.

Second, this implementation requires that the offerer and the accepter perform certain actions themselves.  Other contracts cannot perform the actions on their behalf.  Shall this requirement become an issue the code has to be altered.

## An example contract call

Here I provide an example on how the swap contract can be called.  In this example, **Adam agrees to give Bob 1 Token A to get 1 Token B from Bob**.

### Initial balances

For reference, let check Adam's (tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx) balance of Token A before the transfers:

```tezos-client get big map value for '"tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx"' of type address in tokenA```

The output shows that Adam has 170 Token A, and has approved Bob 30 before the transfer:

~~~~
Pair 170 { Elt 0x000074a095c7f5d1381f5136a970d67af5e569529e9b 30 }
~~~~

Similarly for Bob:

~~~~
tezos-client get big map value for '"tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E"' of type address in tokenB
Pair 140 {}
~~~~

### Deploy the swap contract

A swap contract with the initial storage containing the token amounts and the token contract addresses has to be deployed:

```tezos-client originate contract swap for adam transferring 100 from adam running ~/CryptiumLabs/smarter-contracts/liquidity/swap_contract/swaptokens.tz --init 'Pair 1 (Pair 1 (Pair "KT1Pv3DvEgKmtpiKG8mZWmUAiKFfDfRRjroH" "KT1P6h9yUAaeR3QzacQQdj8yTj8ruxk3s2fH"))' --burn-cap 3 --force```

The output shows the swap contract (KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG) has been injected to the network:

~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 575253 units (will add 100 for safety)
Estimated storage: 2916 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'ootNJkfEKqDKtu18zoHghyfbWXbAPC7rNoUHbiTHAyJi2J6FVad'
Waiting for the operation to be included...
Operation found in block: BMF4fw68RmMrw11DMnuvt9TT8mjiBXCHx3faqBq9r4qEBrw9Sk7 (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
    Fee to the baker: ꜩ0.060482
    Expected counter: 32829
    Gas limit: 575353
    Storage limit: 2936 bytes
    Balance updates:
      tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ............. -ꜩ0.060482
      fees(tz1boot2oCjTjUN6xDNoVmtCLRdh8cc92P1u,272) ... +ꜩ0.060482
    Origination:
      From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
      For: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
      Credit: ꜩ100
      Script:
        [...]
        Initial storage:
          (Pair 1
                (Pair 1
                      (Pair "KT1Pv3DvEgKmtpiKG8mZWmUAiKFfDfRRjroH" "KT1P6h9yUAaeR3QzacQQdj8yTj8ruxk3s2fH")))
        No delegate for this contract
        This origination was successfully applied
        Originated contracts:
          KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG
        Storage size: 2659 bytes
        Paid storage size diff: 2659 bytes
        Consumed gas: 575253
        Balance updates:
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ2.659
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ0.257
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ100
          KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG ... +ꜩ100

New contract KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG originated.
The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ootNJkfEKqDKtu18zoHghyfbWXbAPC7rNoUHbiTHAyJi2J6FVad to be included --confirmations 30 --branch BM3icrvsx581DNPB1o8ZnTbumEZzktZF8KVGDpkpmEBD3epAqEt
and/or an external block explorer.
Contract memorized as swap.
~~~~

### The offerer's actions

The offerer follows the below steps to offer the above swap contract to the market:

#### Check the storage

First, the offerer verifies that the amounts and tokens in the storage are correct:

```tezos-client get script storage for swap``` 

~~~~
Pair 1
     (Pair 1
           (Pair "KT1Pv3DvEgKmtpiKG8mZWmUAiKFfDfRRjroH" "KT1P6h9yUAaeR3QzacQQdj8yTj8ruxk3s2fH"))
~~~~

#### Sign the contract (message)

Then, the offerer signs a message containing the address of the verified swap contract:

First, pack the address into raw data to sign:

```tezos-client hash data '"KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG"' of type address```

~~~~
Raw packed data: 0x050a000000160113b90cc7fbf509ba177bca1e5ab63e90bad4ee4100
Hash: expruCwtnWwwThLq2bNyumVWznVCMCZqBnYcbcP465JaN7SAaWyVCi
Raw Blake2b hash: 0x5afb346b97da67c7e24a359232b4fd1f7bcc4b05e3d531eef38fb58f101957f2
Raw Sha256 hash: 0xefa56bf16571addcc94b246cc9771503e31283221e1e626bd7d6a58a858d945f
Raw Sha512 hash: 0xc297fdea1947e95d98d5aa7cf3421464a2b64c9d231409e4a6361df50d2e2a22f3d1400647d7917dc3db12e5c09cd07ae9fd6a1c052cc71f9623b96f9e2b333f
Gas remaining: 799901 units remaining
~~~~

Then, sign it with ```tezos-client sign bytes data for src```
Sign a raw sequence of bytes and display it using the format expected by Michelson instruction `CHECK_SIGNATURE`. data: the raw data to sign src: source secret_key

```tezos-client sign bytes 0x050a000000160113b90cc7fbf509ba177bca1e5ab63e90bad4ee4100 for adam```

~~~~
Signature: edsigu6d4Tsir3kWPeALPxN25qQ5HEokP5sBHVfEj6uxrh5YZWru6PcKzikQGwo1Q9g1uzHm7Qs1CbqNTCVVX3Dwg3kya6fP9d7
~~~~

Then, the offerer can annouce his offer and the signature.

### The accepter's actions

The accepter has to call the swap contract with the following two parameters:
- the offerer’s public key, 
- the signature of the offerer signing the swap contract (sent by the offerer)

#### To get adam’s public key:

~~~~
tezos-client show address adam
Hash: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
Public Key: edpktnEqY6x6NKdVWQHmLL3WVpqCaqhuGFQnNT62Kqk6hPbEhw8JnP
~~~~

#### Call the contract with the parameters:

```tezos-client transfer 10 from bob to swap --arg '(Pair "edpktnEqY6x6NKdVWQHmLL3WVpqCaqhuGFQnNT62Kqk6hPbEhw8JnP" "edsigu6d4Tsir3kWPeALPxN25qQ5HEokP5sBHVfEj6uxrh5YZWru6PcKzikQGwo1Q9g1uzHm7Qs1CbqNTCVVX3Dwg3kya6fP9d7")'```

~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 730605 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'onxdQ7qZq3zpEMg4QqNkSHtXD8Tk8QpsDnAfjU7VDMbFeZXcarn'
Waiting for the operation to be included...
Operation found in block: BLL5EpzJ8GybMzvfWfMbHhUZhP1oLSTDRWdkB4nmpi1QxYr6q6S (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
    Fee to the baker: ꜩ0.073496
    Expected counter: 32825
    Gas limit: 730705
    Storage limit: 0 bytes
    Balance updates:
      tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E ............. -ꜩ0.073496
      fees(tz1a1AxBfCoGLfDWf2gX4QBc8towpAb3381W,272) ... +ꜩ0.073496
    Transaction:
      Amount: ꜩ10
      From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
      To: KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG
      Parameter: (Pair "edpktnEqY6x6NKdVWQHmLL3WVpqCaqhuGFQnNT62Kqk6hPbEhw8JnP"
                       "edsigu6d4Tsir3kWPeALPxN25qQ5HEokP5sBHVfEj6uxrh5YZWru6PcKzikQGwo1Q9g1uzHm7Qs1CbqNTCVVX3Dwg3kya6fP9d7")
      This transaction was successfully applied
      Updated storage:
        (Pair 1
              (Pair 1
                    (Pair 0x01a82edc4acd7a090cdc5bbed108691d3510fee1e800
                          0x019f3a8ef25d44575a6d6ac5ae98bfc2f0bf2a779900)))
      Storage size: 2659 bytes
      Consumed gas: 310642
      Balance updates:
        tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E ... -ꜩ10
        KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG ... +ꜩ10
    Internal operations:
      Transaction:
        Amount: ꜩ0
        From: KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG
        To: KT1Pv3DvEgKmtpiKG8mZWmUAiKFfDfRRjroH
        Parameter: (Right
                      (Right
                         (Left (Pair 0x00000fb47b79f9e09a7078c52738196d68f542ec69d2
                                     (Pair 0x000074a095c7f5d1381f5136a970d67af5e569529e9b 1)))))
        This transaction was successfully applied
        Updated storage:
          (Pair {}
                (Pair 0
                      (Pair 1000 (Pair "tokenA" (Pair "A" 0x0000c6efaf487d66c90065db616da7432dbdc54b4401)))))
        Storage size: 9768 bytes
        Consumed gas: 210456
      Transaction:
        Amount: ꜩ0
        From: KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG
        To: KT1P6h9yUAaeR3QzacQQdj8yTj8ruxk3s2fH
        Parameter: (Right
                      (Right
                         (Left (Pair 0x000074a095c7f5d1381f5136a970d67af5e569529e9b
                                     (Pair 0x00000fb47b79f9e09a7078c52738196d68f542ec69d2 1)))))
        This transaction was successfully applied
        Updated storage:
          (Pair {}
                (Pair 0
                      (Pair 1000 (Pair "tokenB" (Pair "B" 0x0000c6efaf487d66c90065db616da7432dbdc54b4401)))))
        Storage size: 9737 bytes
        Consumed gas: 209507

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for onxdQ7qZq3zpEMg4QqNkSHtXD8Tk8QpsDnAfjU7VDMbFeZXcarn to be included --confirmations 30 --branch BLu7gJSCvFuYVW8n6BNmHuYrRrJ5UGA1nDAAirjEjFiaZqbu8Yu
and/or an external block explorer.
~~~~

#### When the signature is wrong, failwith is fired:
~~~~
tezos-client transfer 10 from bob to swap --arg '(Pair "edpktnEqY6x6NKdVWQHmLL3WVpqCaqhuGFQnNT62Kqk6hPbEhw8JnP" "edsigu6ZoAx2xUu1ukGBwt6SmUtw5fa3NArB1KptH2FKNSG7UwZuNUEBbqtpM4PJr7kqsVKiDUJVLVu1Zdwetgkdm8y8JKsH8aR")'
~~~~

~~~~
Node is bootstrapped, ready for injecting operations.
This simulation failed:
  Manager signed operations:
    From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
    Fee to the baker: ꜩ0
    Expected counter: 32825
    Gas limit: 800000
    Storage limit: 600000 bytes
    Transaction:
      Amount: ꜩ10
      From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
      To: KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG
      Parameter: (Pair "edpktnEqY6x6NKdVWQHmLL3WVpqCaqhuGFQnNT62Kqk6hPbEhw8JnP"
                       "edsigu6ZoAx2xUu1ukGBwt6SmUtw5fa3NArB1KptH2FKNSG7UwZuNUEBbqtpM4PJr7kqsVKiDUJVLVu1Zdwetgkdm8y8JKsH8aR")
      This operation FAILED.

Runtime error in contract KT1AP45uQwZN3qifwNousE1DL6YR2B4HUxUG:
[......]
At line 117 characters 46 to 54,
script reached FAILWITH instruction
with "Wrong signature"
Fatal error:
  transfer simulation failed
~~~~




