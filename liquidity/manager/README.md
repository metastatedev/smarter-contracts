Compile manager.liq to manager.tz by running:

liquidity [path to]/manager.liq

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

The ```--init``` option initialized the storage to **the KT1 address of the owner of this contract.  This contract can only be called by this owner.**  
The KT1 address (in string format) is wrapped in double quotes.  
Alternatively, one can pass the address in the optimized format, in which case no double quotes should be passed.

For example, I have an account with alias *alice* and I want to initiate the contract, calling it *new_contract*, with the owner being KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU, I'd run the following:

```tezos-client originate contract new_manager for alice transferring 1 from alice running ./manager.tz --init '"KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU"'```

This run fails because the burn-cap for this operation is higher than the default:

~~~~
Node is bootstrapped, ready for injecting operations.
Fatal error:
  The operation will burn ꜩ1.579 which is higher than the configured burn cap (ꜩ0).
   Use `--burn-cap 1.579` to emit this operation.
~~~~

We run the command again, setting the burn cap to 1.579 or above:

```tezos-client originate contract new_manager for alice transferring 1 from alice running ./manager.tz --init '"KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU"' --burn-cap 1.579
```

This time it successfully originate a contract, the output should look similar to this:

~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 40109 units (will add 100 for safety)
Estimated storage: 1579 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'ooektEYoQXwJtGLd2p9Rq6nFD3sjiwhMoZLNnzXGZtN6zcyJtdG'
Waiting for the operation to be included...
Operation found in block: BMYHcat8hixgKv1S6CjjitkJhYzmFebnsXEwtQDjfMYm2XfqSGW (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS
    Fee to the baker: ꜩ0.005614
    Expected counter: 35392
    Gas limit: 40209
    Storage limit: 1599 bytes
    Balance updates:
      tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ............. -ꜩ0.005614
      fees(tz3WXYtyDUNL91qfiCJtVUX746QpNv5i5ve5,166) ... +ꜩ0.005614
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
        Initial storage: "KT1FNANtucrLC4FzGMnyBD945WDkXB86UJDU"
        No delegate for this contract
        This origination was successfully applied
        Originated contracts:
          KT1TwFz7RxvWD298Jd4Pbj7CrW4P2YDHLiKj
        Storage size: 1322 bytes
        Paid storage size diff: 1322 bytes
        Consumed gas: 40109
        Balance updates:
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ1.322
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ0.257
          tz1ccqAEwfPgeoipnXtjAv1iucrpQv3DFmmS ... -ꜩ1
          KT1TwFz7RxvWD298Jd4Pbj7CrW4P2YDHLiKj ... +ꜩ1

New contract KT1TwFz7RxvWD298Jd4Pbj7CrW4P2YDHLiKj originated.
The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ooektEYoQXwJtGLd2p9Rq6nFD3sjiwhMoZLNnzXGZtN6zcyJtdG to be included --confirmations 30 --branch BLxLXRCH4m2B3Vgf9Kpm8zG5oZYM1BHzgPXxVURe6MagprN2wMi
and/or an external block explorer.
Contract memorized as new_manager.
~~~~
