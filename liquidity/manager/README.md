## Compile the contract

Install Liquidity as per the [installation instruction](http://www.liquidity-lang.org/doc/installation/index.html).
Compile manager.liq to manager.tz by running:

```liquidity [path to]/manager.liq```

## Originate the contract on Tezos

To originate the contract, run (see the [client manual](https://tezos.gitlab.io/alphanet/api/cli-commands.html#client-manual) for complete list of options):

```tezos-client originate contract *new* for *mgr* transferring *qty* from *src* running *prg* --init '"[KT1 address]"'```

in which

- **new**: the name you want to give to the contract
- **mgr**: the manager of the new contract 
Can be a public key hash name, a file or a raw public key hash literal. 
If the parameter is not the name of an existing public key hash, 
the client will look for a file containing a public key hash, 
and if it does not exist, the argument will be read as a raw public key hash. 
Use 'alias:name', 'file:path' or 'text:literal' to disable autodetect.
- **qty**: amount taken from source in ꜩ Text format: `DDDDDDD.DDDDDD`. 
Tez and mutez and separated by a period sign. 
Trailing and pending zeroes are allowed. 
- **src**: name of the source contract 
Can be an alias, a key, or a literal (autodetected in order). 
Use 'text:literal', 'alias:name', 'key:name' to force. 
- **prg**: script of the account.  This is **the path to the .tz file that you have saved by compiling manager.liq**.

The ```--init``` option initialized the storage to **the owner of this contract.  This contract can only be called by this owner.**  
The tz1/KT1 address (in string format) is wrapped in double quotes.  
Alternatively, one can pass the address in the optimized format, in which case no double quotes should be passed.

For example, I have an account with alias *alice* and I want to initiate the contract, calling it *new_contract*, with the owner being tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS, I'd run the following:

```tezos-client originate contract new_manager for alice transferring 1 from alice running ./manager.tz --init '"tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS"'```

This run fails because the burn-cap for this operation is higher than the default:

~~~~
Node is bootstrapped, ready for injecting operations.
Fatal error:
  The operation will burn ꜩ1.579 which is higher than the configured burn cap (ꜩ0).
   Use `--burn-cap 1.579` to emit this operation.
~~~~

We run the command again, setting the burn cap to 1.579 or above:

```tezos-client originate contract new_manager for alice transferring 1 from alice running ./manager.tz --init '"tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS"' --burn-cap 1.579
```

This time it successfully originate a contract, the output should look similar to this:

~~~~Node is bootstrapped, ready for injecting operations.
Estimated gas: 40109 units (will add 100 for safety)
Estimated storage: 1579 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'ooEsf896wmE5YniSnSEYN98Qx38X1F53yLNCccCLKPKBsZzeKq8'
Waiting for the operation to be included...
Operation found in block: BKoY5wVTspvAwKm3PoEUu1miMKKnY5q3cuCRHEQsCKU48rDmM3C (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0.005614
    Expected counter: 35394
    Gas limit: 40209
    Storage limit: 1599 bytes
    Balance updates:
      tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ............. -ꜩ0.005614
      fees(tz1YCABRTa6H8PLKx2EtDWeCGPaKxUhNgv47,166) ... +ꜩ0.005614
    Origination:
      From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      For: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      Credit: ꜩ1
      Script:
        { parameter
            (or :_entries
               (pair %_Liq_entry_spendFund key_hash mutez)
               (or (key_hash %_Liq_entry_change_delegate)
                   (or (unit %_Liq_entry_remove_delegate) (address %_Liq_entry_change_owner)))) ;
          storage address ;
          code { DUP ;
                 DIP { CDR @storage_slash_1 } ;
                 CAR @parameter_slash_2 ;
                 DUP @parameter ;
                 IF_LEFT
                   { RENAME @_toAddress_toAmount_slash_3 ;
                     { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                     DUP @owner ;
                     SENDER ;
                     COMPARE ;
                     NEQ ;
                     IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
                        { DUUP ;
                          CAR @toAddress ;
                          IMPLICIT_ACCOUNT ;
                          DUUUP ;
                          CDR @toAmount ;
                          UNIT ;
                          TRANSFER_TOKENS @op ;
                          { DIP { DUP @owner } ; SWAP } ;
                          NIL operation ;
                          { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
                          DIIIP { DROP } ;
                          CONS ;
                          PAIR } ;
                     DIP { DROP ; DROP } }
                   (IF_RIGHT
                      (IF_RIGHT
                         { RENAME @new_owner_slash_14 ;
                           { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                           SENDER ;
                           COMPARE ;
                           NEQ ;
                           IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
                              { DUP @new_owner ; NIL operation ; PAIR } ;
                           DIP { DROP } }
                         { RENAME @__slash_11 ;
                           { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                           DUP @owner ;
                           SENDER ;
                           COMPARE ;
                           NEQ ;
                           IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
                              { NONE key_hash ;
                                SET_DELEGATE @op ;
                                { DIP { DUP @owner } ; SWAP } ;
                                NIL operation ;
                                { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
                                DIIIP { DROP } ;
                                CONS ;
                                PAIR } ;
                           DIP { DROP ; DROP } })
                      { RENAME @new_del_slash_8 ;
                        { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                        DUP @owner ;
                        SENDER ;
                        COMPARE ;
                        NEQ ;
                        IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
                           { { DIP { DUP @new_del } ; SWAP } ;
                             SOME ;
                             SET_DELEGATE @op ;
                             { DIP { DUP @owner } ; SWAP } ;
                             NIL operation ;
                             { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
                             DIIIP { DROP } ;
                             CONS ;
                             PAIR } ;
                        DIP { DROP ; DROP } }) ;
                 DIP { DROP ; DROP } } }
        Initial storage: "tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS"
        No delegate for this contract
        This origination was successfully applied
        Originated contracts:
          KT1SimGFMnQyCSV2Hk8oSmx5hgPmuJin3Zsi
        Storage size: 1322 bytes
        Paid storage size diff: 1322 bytes
        Consumed gas: 40109
        Balance updates:
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ1.322
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ0.257
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ1
          KT1SimGFMnQyCSV2Hk8oSmx5hgPmuJin3Zsi ... +ꜩ1

New contract KT1SimGFMnQyCSV2Hk8oSmx5hgPmuJin3Zsi originated.
The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ooEsf896wmE5YniSnSEYN98Qx38X1F53yLNCccCLKPKBsZzeKq8 to be included --confirmations 30 --branch BM8fpfLjGDNrFKbkEZrzFSQnWmjYDzXNZo7xoor9iWQK2RS9mcZ
and/or an external block explorer.
Contract memorized as new_manager.

~~~~

## Call the contract

The contract has the following functions:

1. Transfer funds: 
 - the parameters to pass are 
   - the *key_hash* of the recipient that you want to send the fund to
   - the amount you want to send 
 - first entry point of the contract, pass the parameters by passing ```Left [parameters]```
2. Set delegate: 
 - the parameter to pass is the *key_hash* of the delegate
 - second entry point of the contract, pass the parameter by passing ```(Right (Left [parameter]))```
3. Remove delegate
 - the parameter to pass is *unit*
 - third entry point of the contract, pass the parameter by passing ```(Right (Right (Left [parameter])))```
4. Change owner
 - the parameter to pass is the new owner's address
 - fourth entry point of the contract, pass the parameter by passing ```(
 
 I provide some examples below:

### Set delegate

To set a new delegate to tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD, run the following command:

```tezos-client transfer 10 from alice to new_manager --arg '(Right (Left "tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6"))'```

The output should be similar to this, stating that the delegate is set to the new address that we pass in:

~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 43492 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'oovjp8KipYBpMDsXhhUUNVbVT9dbpf61BLCsmVYNRZj5tPThQsU'
Waiting for the operation to be included...
Operation found in block: BLsBaUyg7MDAFFBhXKTGU5DLgSdR2VMfvy5HRtgkNti7daEW57S (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0.004664
    Expected counter: 35399
    Gas limit: 43592
    Storage limit: 0 bytes
    Balance updates:
      tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ............. -ꜩ0.004664
      fees(tz1hodJSw6uv7LqArLW86zKuUjkXiayJvqCf,166) ... +ꜩ0.004664
    Transaction:
      Amount: ꜩ10
      From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      To: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
      Parameter: (Right (Left "tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6"))
      This transaction was successfully applied
      Updated storage: 0x0000ba40187a5d588d3312be6321f7bdc077b0fc2a6a
      Storage size: 1322 bytes
      Consumed gas: 33492
      Balance updates:
        tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ10
        KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8 ... +ꜩ10
    Internal operations:
      Delegation:
        Contract: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
        To: tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6
        This delegation was successfully applied
        Consumed gas: 10000

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for oovjp8KipYBpMDsXhhUUNVbVT9dbpf61BLCsmVYNRZj5tPThQsU to be included --confirmations 30 --branch BM7Gxytb4kYiSFBubLBbMDsQdNQehFZfp2DNPf5ysFqpsDsVYwY
and/or an external block explorer.
~~~~

Check again that the delegate is the new address:

```tezos-client get delegate for new_manager```

The output is the new delegate:

```tz1Ra8yQVQN4Nd7LpPQ6UT6t3bsWWqHZ9wa6 (known as bob)```

### Remove delegate

To removing a delegate, we pass the input *unit* to the third entry point by running the following:

```tezos-client transfer 10 from alice to new_manager --arg '(Right (Right (Left Unit)))'```

The output states that delegate is set to *none*:
~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 43491 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'opHtivqYJzmKEzQbNyQbUnxKJcPo2x5NW2BMtjWaKDJ5jtmJvEQ'
Waiting for the operation to be included...
Operation found in block: BKmaUwqtnGkGzEbTTKsq43LuVsKrv8r2x5g5M7pcwF9EgEBieqb (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0.004627
    Expected counter: 35400
    Gas limit: 43591
    Storage limit: 0 bytes
    Balance updates:
      tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ............. -ꜩ0.004627
      fees(tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5,166) ... +ꜩ0.004627
    Transaction:
      Amount: ꜩ10
      From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      To: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
      Parameter: (Right (Right (Left Unit)))
      This transaction was successfully applied
      Updated storage: 0x0000ba40187a5d588d3312be6321f7bdc077b0fc2a6a
      Storage size: 1322 bytes
      Consumed gas: 33491
      Balance updates:
        tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ10
        KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8 ... +ꜩ10
    Internal operations:
      Delegation:
        Contract: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
        To: nobody
        This delegation was successfully applied
        Consumed gas: 10000

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for opHtivqYJzmKEzQbNyQbUnxKJcPo2x5NW2BMtjWaKDJ5jtmJvEQ to be included --confirmations 30 --branch BLsBaUyg7MDAFFBhXKTGU5DLgSdR2VMfvy5HRtgkNti7daEW57S
and/or an external block explorer.
~~~~

Check the delegate for new_manager again shows that there is indeed no delegate:
~~~~
tezos-client get delegate for new_manager
none
~~~~

### Change owner

To change the owner of the contract to tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD, we run the following:

```tezos-client transfer 10 from alice to new_manager --arg '(Right (Right (Right "tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD")))'```

The output indicates that the storage has been updated to the new owner's address (in optimized form): 

~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 33427 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'ooT9t9cAUkjPgmgHNDY4Uk9Kp6aB7yPhDyQeG5WoM4uDU6xpNWy'
Waiting for the operation to be included...
Operation found in block: BLdLuXvedcHzDK9BBR4deJWiD6mkeePo8uMbbVhtFNgtLHPCAfh (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0.003659
    Expected counter: 35401
    Gas limit: 33527
    Storage limit: 0 bytes
    Balance updates:
      tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ............. -ꜩ0.003659
      fees(tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5,166) ... +ꜩ0.003659
    Transaction:
      Amount: ꜩ10
      From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      To: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
      Parameter: (Right (Right (Right "tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD")))
      This transaction was successfully applied
      Updated storage: 0x0000d8aebdc7e7d86e00d26b5f9c038dd87b01631ba6
      Storage size: 1322 bytes
      Consumed gas: 33427
      Balance updates:
        tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ10
        KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8 ... +ꜩ10

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ooT9t9cAUkjPgmgHNDY4Uk9Kp6aB7yPhDyQeG5WoM4uDU6xpNWy to be included --confirmations 30 --branch BLJSrBbPiQDYavpAuE8hMXFwEfAuT15uE6WRkGpzfoBp8Pz8K7r
and/or an external block explorer.
~~~~

Now, calling the contract with alice fails, because the owner is not alice anymore:

```tezos-client transfer 10 from alice to new_manager --arg '(Right (Right (Right "tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD")))'```

The output indicates that it fails with error "Only the owner can operate.":

~~~~
Node is bootstrapped, ready for injecting operations.
This simulation failed:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0
    Expected counter: 35402
    Gas limit: 400000
    Storage limit: 60000 bytes
    Transaction:
      Amount: ꜩ10
      From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
      To: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
      Parameter: (Right (Right (Right "tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD")))
      This operation FAILED.

Runtime error in contract KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8:
  01: { parameter
  02:     (or :_entries
  03:        (pair %_Liq_entry_spendFund key_hash mutez)
  04:        (or (key_hash %_Liq_entry_change_delegate)
  05:            (or (unit %_Liq_entry_remove_delegate) (address %_Liq_entry_change_owner)))) ;
  06:   storage address ;
  07:   code { DUP ;
  08:          DIP { CDR @storage_slash_1 } ;
  09:          CAR @parameter_slash_2 ;
  10:          DUP @parameter ;
  11:          IF_LEFT
  12:            { RENAME @_toAddress_toAmount_slash_3 ;
  13:              { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  14:              DUP @owner ;
  15:              SENDER ;
  16:              COMPARE ;
  17:              NEQ ;
  18:              IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
  19:                 { DUUP ;
  20:                   CAR @toAddress ;
  21:                   IMPLICIT_ACCOUNT ;
  22:                   DUUUP ;
  23:                   CDR @toAmount ;
  24:                   UNIT ;
  25:                   TRANSFER_TOKENS @op ;
  26:                   { DIP { DUP @owner } ; SWAP } ;
  27:                   NIL operation ;
  28:                   { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
  29:                   DIIIP { DROP } ;
  30:                   CONS ;
  31:                   PAIR } ;
  32:              DIP { DROP ; DROP } }
  33:            (IF_RIGHT
  34:               (IF_RIGHT
  35:                  { RENAME @new_owner_slash_14 ;
  36:                    { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  37:                    SENDER ;
  38:                    COMPARE ;
  39:                    NEQ ;
  40:                    IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
  41:                       { DUP @new_owner ; NIL operation ; PAIR } ;
  42:                    DIP { DROP } }
  43:                  { RENAME @__slash_11 ;
  44:                    { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  45:                    DUP @owner ;
  46:                    SENDER ;
  47:                    COMPARE ;
  48:                    NEQ ;
  49:                    IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
  50:                       { NONE key_hash ;
  51:                         SET_DELEGATE @op ;
  52:                         { DIP { DUP @owner } ; SWAP } ;
  53:                         NIL operation ;
  54:                         { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
  55:                         DIIIP { DROP } ;
  56:                         CONS ;
  57:                         PAIR } ;
  58:                    DIP { DROP ; DROP } })
  59:               { RENAME @new_del_slash_8 ;
  60:                 { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  61:                 DUP @owner ;
  62:                 SENDER ;
  63:                 COMPARE ;
  64:                 NEQ ;
  65:                 IF { SENDER ; PUSH string "Only the owner can operate." ; PAIR ; FAILWITH }
  66:                    { { DIP { DUP @new_del } ; SWAP } ;
  67:                      SOME ;
  68:                      SET_DELEGATE @op ;
  69:                      { DIP { DUP @owner } ; SWAP } ;
  70:                      NIL operation ;
  71:                      { DIP { DIP { DUP @op } ; SWAP } ; SWAP } ;
  72:                      DIIIP { DROP } ;
  73:                      CONS ;
  74:                      PAIR } ;
  75:                 DIP { DROP ; DROP } }) ;
  76:          DIP { DROP ; DROP } } }
At line 40 characters 84 to 92,
script reached FAILWITH instruction
with
  (Pair "Only the owner can operate." 0x0000ba40187a5d588d3312be6321f7bdc077b0fc2a6a)
Fatal error:
  transfer simulation failed
~~~~

Calling the contract with adam (the new owner) works:
~~~~
tezos-client transfer 10 from adam to new_manager --arg '(Right (Right (Left Unit)))'
Node is bootstrapped, ready for injecting operations.
Estimated gas: 43491 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'ooSsE3SwitQZv4JdmRoHjX9frpd3qbxz7CJt2ZLDHMAURRMbBm6'
Waiting for the operation to be included...
Operation found in block: BMLtAzzCVAEmD7GFv7rwDeyAfZ7iahjubMcqU4QGg3HnZBUuvV6 (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD
    Fee to the baker: ꜩ0.00126
    Expected counter: 40372
    Gas limit: 10000
    Storage limit: 0 bytes
    Balance updates:
      tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD ............. -ꜩ0.00126
      fees(tz1hodJSw6uv7LqArLW86zKuUjkXiayJvqCf,166) ... +ꜩ0.00126
    Revelation of manager public key:
      Contract: tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD
      Key: edpkv9VKRsxHheJLX8ZnYZhT7cvZ34n9Dryz4RgWqabwr8F6tAUx7v
      This revelation was successfully applied
      Consumed gas: 10000
  Manager signed operations:
    From: tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD
    Fee to the baker: ꜩ0.004531
    Expected counter: 40373
    Gas limit: 43591
    Storage limit: 0 bytes
    Balance updates:
      tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD ............. -ꜩ0.004531
      fees(tz1hodJSw6uv7LqArLW86zKuUjkXiayJvqCf,166) ... +ꜩ0.004531
    Transaction:
      Amount: ꜩ10
      From: tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD
      To: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
      Parameter: (Right (Right (Left Unit)))
      This transaction was successfully applied
      Updated storage: 0x0000d8aebdc7e7d86e00d26b5f9c038dd87b01631ba6
      Storage size: 1322 bytes
      Consumed gas: 33491
      Balance updates:
        tz1fPjyo55HwUAkd1xcL5vo6DGzJrkxAMpiD ... -ꜩ10
        KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8 ... +ꜩ10
    Internal operations:
      Delegation:
        Contract: KT1PTu7zW8rDMkHsLL9wkBJUH5PqJ2kdmSi8
        To: nobody
        This delegation was successfully applied
        Consumed gas: 10000

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ooSsE3SwitQZv4JdmRoHjX9frpd3qbxz7CJt2ZLDHMAURRMbBm6 to be included --confirmations 30 --branch BLY6MXnBaxAy597XS3F8oabFV4VvEoV23DCVV69kuAbeSMTuWUi
and/or an external block explorer.
~~~~
