This contract sends one tz to another account.

In this contract the storage is *unit*.  The parameter is the *key_hash* of the receiver of the 1tz.
 
To verify the contract does what it intends to do, one has to deploy and call it, then check the balance of the sender and the receiver.

E.g., I have two account alice and bob activated.  Follow [this link](http://tezos.gitlab.io/mainnet/introduction/howtouse.html#how-to-use-tezos) for instructions on activating these accounts.

I have alice originating the contract i.e. alice is the sender of 1tz.  
 
After compiling send_one_tez.liq to .tz (by running ```liquidity send_one_tez.liq```), deploy the contract with: (```--force``` is only necessary if you have originated this contract before.)  ```--burn-cap``` set the burn cap.  You can first run it without the burn-cap option, and the client will tell you how much it needs to be set to.
 
```tezos-client originate contract sendtez for alice transferring 1 from alice running [path to]/send_one_tez.tz --force --burn-cap 0.43```

This generates a contract named *sendtez* and it should return "new contract originated with a KT1 address.  In my case 'KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU'.

Running ```tezos-client list known contracts``` now list the new contract *sendtez*:  

~~~~
sendtez: KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU  
bob: tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6  
alice: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS  
~~~~

The contract is injected to alphanet.  To call the contract, we need to know alice’s private key and hash, and bob’s hash.

Running ```tezos-client show address alice -S --show-secret``` shows the following for alice:
~~~~
Hash: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
Public Key: edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes
Secret Key: unencrypted:edsk2gKnmssYQB5sNCAL6sCcgfPRZDuK1zixBowAQ1H1WCt78JxEhf
~~~~
Running ```tezos-client show address bob -S --show-secret``` shows the following for bob:
~~~~
Hash: tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6
Public Key: edpktqrmQgDqvdCZM4msb9eDpe2adQ6NDgE7Jax34ABPzvw2Pk9SaT
Secret Key: unencrypted:edsk2pyAwDyHGh22tFAre3Qghz1JY3D1eT6yWnZVbidVJstzYxTAKK
~~~~
Before we call the contract, which will execute the transfer of 1tz, let’s check the balances of alice and bob with 

```tezos-client get balance for alice```
```tezos-client get balance for bob```

Now we can call the contract with alice's private key, and the liquidity command (see the full list of commands with ```liquidity --help```) ```--call [contract address] [entry point name] [receipent's key_hash]``` (in my case, bob’s key hash):

 ```liquidity --tezos-node http://alphanet-node.tzscan.io --private-key edsk2gKnmssYQB5sNCAL6sCcgfPRZDuK1zixBowAQ1H1WCt78JxEhf --source tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS [path to]/send_one_tez.liq --call KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU main 'tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6'```


The Tezos client should inform you the call was successful.  To check that one tez is transferred from alice to bob, check their balances again.  Note that alice has to pay for the transaction as well on top of the 1tz to bob.



