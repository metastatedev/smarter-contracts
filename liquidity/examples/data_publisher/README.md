# Testing the data query function:

When the input data is *None*, it is a data query, and the script checks that transfer amount is no less than 1tz.

## Running the script via liquidity returns a 'Sys_error'
~~~~
liquidity --tezos-node http://127.0.0.1:8732 --amount 2tz \ CryptiumLabs/smarter-contracts/liquidity/examples/data_publisher/data_publisher.liq --run main 'None' 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")'

~~~~

Output:
~~~~
Error: Sys_error(" CryptiumLabs/smarter-contracts/liquidity/examples/data_publisher/data_publisher.liq: No such file or directory")  
Backtrace:
Raised by primitive operation at file "pervasives.ml", line 389, characters 28-54
Called from file "pervasives.ml", line 394, characters 2-45
Called from file "./tools/liquidity/liquidFromParsetree.ml", line 2399, characters 6-34
Called from file "arg.ml", line 281, characters 4-31
Called from file "./tools/liquidity/liquidMain.ml", line 793, characters 4-74
~~~~

## Running the script via the tezos-client shows desired results

### When the amount is less than 1tz, a runtime error occurs:

When no ```--amount``` input is passed, the default amount (0.05tz) is passed.  Therefore, a runtime error should occur.
~~~~
tezos-client run script data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'None'  
~~~~
Output shows the error message of "Not enough money, queries cost 1 tez.":
~~~~
Runtime error in contract KT1BEqzn5Wx8uJrZNvuS9DVHmLvG9td3fDLi:
  01: parameter
  02:   (option
  03:      (pair :parameter (signature %signature) (pair (string %string) (nat %number_of_op))));
  04: storage (pair :storage (key %key) (pair (nat %counter) (string %message)));
  05: code { DUP ;
  06:        DIP { CDR @storage_slash_1 } ;
  07:        CAR @param_slash_2 ;
  08:        DUP @param ;
  09:        IF_NONE
  10:          { PUSH mutez 1000000 ;
  11:            AMOUNT ;
  12:            COMPARE ;
  13:            LT ;
  14:            IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  15:               { DUUP @storage ; NIL operation ; PAIR } }
  16:          { PUSH nat 1 ;
  17:            DUUUUP @storage ;
  18:            CDAR %counter ;
  19:            ADD ;
  20:            DUUP @p ;
  21:            CDDR %number_of_op ;
  22:            COMPARE ;
  23:            NEQ ;
  24:            DUUP @p ;
  25:            CDAR %string ;
  26:            PACK @bytes ;
  27:            DUUUP @p ;
  28:            CAR %signature ;
  29:            DUUUUUUP @storage ;
  30:            CAR %key ;
  31:            CHECK_SIGNATURE ;
  32:            NOT ;
  33:            OR ;
  34:            IF { PUSH string "Cannot authenticate." ; FAILWITH }
  35:               { DUP @p ;
  36:                 CDAR %string ;
  37:                 PUSH nat 1 ;
  38:                 DUUUUUP @storage ;
  39:                 CDAR %counter ;
  40:                 ADD ;
  41:                 PAIR %counter %message ;
  42:                 DUUUUP @storage ;
  43:                 CAR %key ;
  44:                 PAIR @new_data %key ;
  45:                 NIL operation ;
  46:                 PAIR } ;
  47:            DIP { DROP } } ;
  48:        DIP { DROP ; DROP } };
  49: 
At line 14 characters 70 to 78,
script reached FAILWITH instruction
with "Not enough money, queries cost 1 tez."
Fatal error:
  error running script
~~~~



When 0.8tz is passed, the same error occurs:

```tezos-client run script data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'None' --amount 0.8```

Output:

~~~~
Runtime error in contract KT1BEqzn5Wx8uJrZNvuS9DVHmLvG9td3fDLi:
  01: parameter
  02:   (option
  03:      (pair :parameter (signature %signature) (pair (string %string) (nat %number_of_op))));
  04: storage (pair :storage (key %key) (pair (nat %counter) (string %message)));
  05: code { DUP ;
  06:        DIP { CDR @storage_slash_1 } ;
  07:        CAR @param_slash_2 ;
  08:        DUP @param ;
  09:        IF_NONE
  10:          { PUSH mutez 1000000 ;
  11:            AMOUNT ;
  12:            COMPARE ;
  13:            LT ;
  14:            IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  15:               { DUUP @storage ; NIL operation ; PAIR } }
  16:          { PUSH nat 1 ;
  17:            DUUUUP @storage ;
  18:            CDAR %counter ;
  19:            ADD ;
  20:            DUUP @p ;
  21:            CDDR %number_of_op ;
  22:            COMPARE ;
  23:            NEQ ;
  24:            DUUP @p ;
  25:            CDAR %string ;
  26:            PACK @bytes ;
  27:            DUUUP @p ;
  28:            CAR %signature ;
  29:            DUUUUUUP @storage ;
  30:            CAR %key ;
  31:            CHECK_SIGNATURE ;
  32:            NOT ;
  33:            OR ;
  34:            IF { PUSH string "Cannot authenticate." ; FAILWITH }
  35:               { DUP @p ;
  36:                 CDAR %string ;
  37:                 PUSH nat 1 ;
  38:                 DUUUUUP @storage ;
  39:                 CDAR %counter ;
  40:                 ADD ;
  41:                 PAIR %counter %message ;
  42:                 DUUUUP @storage ;
  43:                 CAR %key ;
  44:                 PAIR @new_data %key ;
  45:                 NIL operation ;
  46:                 PAIR } ;
  47:            DIP { DROP } } ;
  48:        DIP { DROP ; DROP } };
  49: 
At line 14 characters 70 to 78,
script reached FAILWITH instruction
with "Not enough money, queries cost 1 tez."
Fatal error:
  error running script
~~~~

### When the amount is no less than 1tz, the script ran:

With amount set to 1:

```tezos-client run script data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'None' --amount 1```

Output:
~~~~
storage
  (Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init"))
emitted operations
~~~~

With amount set to 2:

```tezos-client run script data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'None' --amount 2```

Output:

~~~~
storage
  (Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init"))
emitted operations
~~~~

# Testing the data publishing function:

When the publisher wants to publish, the script checks that the publisher has signed the updated message content with its secrete key.  The publisher also has to provide the number of times of publishing.  If the script only updates the storage (the published data) if it can authenticate.

## Sign the message to be published

The data publisher first needs to sign the message it is publishing with its secret key, using the following command of the tezos-client:

-----------------------------------------

```sign bytes``` **data** ```for``` **src**  
Sign a raw sequence of bytes and display it using the format expected by Michelson instruction `CHECK_SIGNATURE`.  
**data**: the raw data to sign  
**src**: source secret_key  
  Can be a secret_key name, a file or a raw secret_key literal.  

-------------------------------------------

**Never** publish a secret key that is associated with a real account.

alice is the publisher in my case, and she is signing the message "test":

### Pack the message so that it can be signed

Because the data has to be in the raw data format, we first need to *pack* the data and get the raw packed data using the following:

-----------------------------------------------
```hash data``` **data** ```of``` **type** ```type [-G --gas <gas>]```  
Ask the node to pack a data expression.  
  The returned hash is the same as what Michelson instruction `PACK` would
  have produced.  
  Also displays the result of hashing this packed data with `BLAKE2B`,
  `SHA256` or `SHA512` instruction.  
**data**: the data to hash  
**type**: type of the data  
```-G --gas <gas>```: Initial quantity of gas for typechecking and execution  

----------------------------------------

Run the following to pack the data:
```tezos-client hash data '"test"' of type string ```

Output:
~~~~
Raw packed data: 0x05010000000474657374
Hash: exprvNX6heZJnVkgZf8Xvq9DKEJE3mazxE69KxVSFxGi2RYQqNpKWz
Raw Blake2b hash: 0xf469b4b81d129423d921abff411e2e48f729605f6548bdd8c9f616e29b8cabe6
Raw Sha256 hash: 0x5cedc49191ca9f6a0af917b23dd897c11b125970af57bd6c8f033edccf913e68
Raw Sha512 hash: 0xd6678c7250c54e4384637a72e1f7a5d0369dd279a64645b0ddc8b170f5b6a00c0377bdbb56255dcbe13f3d32fa128b52721fbf009b84f8a3feaee8110532759e
Gas remaining: 399918 units remaining
~~~~

The first line of output is the raw packed data we want to pass into the following command to obtain a signature:

```tezos-client sign bytes '0x05010000000474657374' for alice```

Output:

```Signature: edsigtc3ViMeEbg3EE9xFicJZoxuQYMGWU4Aqk8ruDcQFh5mHsYf1ujK2TdFzw9RHkVp6VfhQMW9CZTv555Y8oJ7JLpvk6FUdLX```

This signature is required as part of the input data to deploy the contract to publish the data.  Along with the message to be published, and a natural number.  The natural number counts the number of times the publisher has published, to avoid attacks resetting the message to an old one.

## Run the script

Finally, we can test the script with the ```run script``` command, with our storage and input:

- Storage data (for first time run, use the content from the data_publisher.init.tz file): 
Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")  
- input data (an *option* of a *record* with the signature (type *signature*), the string (type *string*), and the number of times of publishing (type *nat*):   
Some (Pair "edsigtc3ViMeEbg3EE9xFicJZoxuQYMGWU4Aqk8ruDcQFh5mHsYf1ujK2TdFzw9RHkVp6VfhQMW9CZTv555Y8oJ7JLpvk6FUdLX" (Pair "test" 1 ))  

```tezos-client run script CryptiumLabs/smarter-contracts/liquidity/examples/data_publisher/data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'Some (Pair "edsigtc3ViMeEbg3EE9xFicJZoxuQYMGWU4Aqk8ruDcQFh5mHsYf1ujK2TdFzw9RHkVp6VfhQMW9CZTv555Y8oJ7JLpvk6FUdLX" (Pair "test" 1 ))'```

The output shows that the data is successfully updated, as the signature and the number of times of publishing are correct:
~~~~
storage
  (Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 1 "test"))
emitted operations
~~~~

When the number of times of publishing is wrong, the update fails with the error message "Cannot authenticate.":

```tezos-client run script CryptiumLabs/smarter-contracts/liquidity/examples/data_publisher/data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'Some (Pair "edsigtc3ViMeEbg3EE9xFicJZoxuQYMGWU4Aqk8ruDcQFh5mHsYf1ujK2TdFzw9RHkVp6VfhQMW9CZTv555Y8oJ7JLpvk6FUdLX" (Pair "test" 2 ))'```

Output:
~~~~
Runtime error in contract KT1BEqzn5Wx8uJrZNvuS9DVHmLvG9td3fDLi:
  01: parameter
  02:   (option
  03:      (pair :parameter (signature %signature) (pair (string %string) (nat %number_of_op))));
  04: storage (pair :storage (key %key) (pair (nat %counter) (string %message)));
  05: code { DUP ;
  06:        DIP { CDR @storage_slash_1 } ;
  07:        CAR @param_slash_2 ;
  08:        DUP @param ;
  09:        IF_NONE
  10:          { PUSH mutez 1000000 ;
  11:            AMOUNT ;
  12:            COMPARE ;
  13:            LT ;
  14:            IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  15:               { DUUP @storage ; NIL operation ; PAIR } }
  16:          { PUSH nat 1 ;
  17:            DUUUUP @storage ;
  18:            CDAR %counter ;
  19:            ADD ;
  20:            DUUP @p ;
  21:            CDDR %number_of_op ;
  22:            COMPARE ;
  23:            NEQ ;
  24:            DUUP @p ;
  25:            CDAR %string ;
  26:            PACK @bytes ;
  27:            DUUUP @p ;
  28:            CAR %signature ;
  29:            DUUUUUUP @storage ;
  30:            CAR %key ;
  31:            CHECK_SIGNATURE ;
  32:            NOT ;
  33:            OR ;
  34:            IF { PUSH string "Cannot authenticate." ; FAILWITH }
  35:               { DUP @p ;
  36:                 CDAR %string ;
  37:                 PUSH nat 1 ;
  38:                 DUUUUUP @storage ;
  39:                 CDAR %counter ;
  40:                 ADD ;
  41:                 PAIR %counter %message ;
  42:                 DUUUUP @storage ;
  43:                 CAR %key ;
  44:                 PAIR @new_data %key ;
  45:                 NIL operation ;
  46:                 PAIR } ;
  47:            DIP { DROP } } ;
  48:        DIP { DROP ; DROP } };
  49: 
At line 34 characters 53 to 61,
script reached FAILWITH instruction
with "Cannot authenticate."
Fatal error:
  error running script
~~~~

The update also fails when the signature is incorrect:

In this command the signature signed the message to be "test", but the input data has the message "tet":

```tezos-client run script CryptiumLabs/smarter-contracts/liquidity/examples/data_publisher/data_publisher.tz on storage 'Pair "edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes" (Pair 0 "init")' and input 'Some (Pair "edsigtc3ViMeEbg3EE9xFicJZoxuQYMGWU4Aqk8ruDcQFh5mHsYf1ujK2TdFzw9RHkVp6VfhQMW9CZTv555Y8oJ7JLpvk6FUdLX" (Pair "tet" 1 ))'```

Output:

~~~~
Runtime error in contract KT1BEqzn5Wx8uJrZNvuS9DVHmLvG9td3fDLi:
  01: parameter
  02:   (option
  03:      (pair :parameter (signature %signature) (pair (string %string) (nat %number_of_op))));
  04: storage (pair :storage (key %key) (pair (nat %counter) (string %message)));
  05: code { DUP ;
  06:        DIP { CDR @storage_slash_1 } ;
  07:        CAR @param_slash_2 ;
  08:        DUP @param ;
  09:        IF_NONE
  10:          { PUSH mutez 1000000 ;
  11:            AMOUNT ;
  12:            COMPARE ;
  13:            LT ;
  14:            IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  15:               { DUUP @storage ; NIL operation ; PAIR } }
  16:          { PUSH nat 1 ;
  17:            DUUUUP @storage ;
  18:            CDAR %counter ;
  19:            ADD ;
  20:            DUUP @p ;
  21:            CDDR %number_of_op ;
  22:            COMPARE ;
  23:            NEQ ;
  24:            DUUP @p ;
  25:            CDAR %string ;
  26:            PACK @bytes ;
  27:            DUUUP @p ;
  28:            CAR %signature ;
  29:            DUUUUUUP @storage ;
  30:            CAR %key ;
  31:            CHECK_SIGNATURE ;
  32:            NOT ;
  33:            OR ;
  34:            IF { PUSH string "Cannot authenticate." ; FAILWITH }
  35:               { DUP @p ;
  36:                 CDAR %string ;
  37:                 PUSH nat 1 ;
  38:                 DUUUUUP @storage ;
  39:                 CDAR %counter ;
  40:                 ADD ;
  41:                 PAIR %counter %message ;
  42:                 DUUUUP @storage ;
  43:                 CAR %key ;
  44:                 PAIR @new_data %key ;
  45:                 NIL operation ;
  46:                 PAIR } ;
  47:            DIP { DROP } } ;
  48:        DIP { DROP ; DROP } };
  49: 
At line 34 characters 53 to 61,
script reached FAILWITH instruction
with "Cannot authenticate."
Fatal error:
  error running script
~~~~



