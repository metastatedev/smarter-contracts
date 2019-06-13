# Deploy

Using the tezos-client, I ran the following command to deploy the contract:
- I named the contract *publisher*
- **adam** (tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx) is the manager 
- recall the ```--init``` option is the input for the initial storage. In this example the input is ```'Pair "tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx" "init"'```. In Michelson we input a record with two fields as a *pair*. The first item of the *pair* is the address of the publisher (adam with address "tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx"). The second item is the data to be published ("init").

~~~~
tezos-client originate contract publisher for adam transferring 1 from adam running data_publisher.tz --init 'Pair "tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx" "init"' --burn-cap 0.774
~~~~
~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 21524 units (will add 100 for safety)
Estimated storage: 774 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'opMguaAvqFRf2qVcKt8XAh3og1WxJLDqC24SG6V3xZNCjcGAcS3'
Waiting for the operation to be included...
Operation found in block: BMMaSCEwLDKaXHNBrnMSvpzXGvCeZRWbErkgn1PkA6rdm26k3No (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
    Fee to the baker: ꜩ0.002951
    Expected counter: 32830
    Gas limit: 21624
    Storage limit: 794 bytes
    Balance updates:
      tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx .............. -ꜩ0.002951
      fees(tz1aWXP237BLwNHJcCD4b3DutCevhqq2T1Z9,1160) ... +ꜩ0.002951
    Origination:
      From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
      For: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
      Credit: ꜩ1
      Script:
        { parameter (option string) ;
          storage (pair :storage (address %publisher) (string %data)) ;
          code { DUP ;
                 DIP { CDR @storage_slash_1 } ;
                 CAR @param_slash_2 ;
                 DUP @param ;
                 IF_NONE
                   { PUSH mutez 1000000 ;
                     AMOUNT ;
                     COMPARE ;
                     LT ;
                     IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
                        { { DIP { DUP @storage } ; SWAP } ; NIL operation ; PAIR } }
                   { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                     CAR %publisher ;
                     SENDER ;
                     COMPARE ;
                     NEQ ;
                     IF { PUSH string "Cannot authenticate." ; FAILWITH }
                        { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
                          CAR %publisher ;
                          { DIP { DUP @p } ; SWAP } ;
                          SWAP ;
                          PAIR %publisher %data ;
                          NIL operation ;
                          PAIR } ;
                     DIP { DROP } } ;
                 DIP { DROP ; DROP } } }
        Initial storage: (Pair "tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx" "init")
        No delegate for this contract
        This origination was successfully applied
        Originated contracts:
          KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2
        Storage size: 517 bytes
        Paid storage size diff: 517 bytes
        Consumed gas: 21524
        Balance updates:
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ0.517
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ0.257
          tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ1
          KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2 ... +ꜩ1

New contract KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2 originated.
The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for opMguaAvqFRf2qVcKt8XAh3og1WxJLDqC24SG6V3xZNCjcGAcS3 to be included --confirmations 30 --branch BKvbfwbCqtSUnmA8yLh2wvremriKGjswc5FWnquQGFkDXHzGp9H
and/or an external block explorer.
Contract memorized as publisher.
~~~~

# Call to update data

To update the data, adam has to call the contract, and the storage is updated:

~~~~
tezos-client transfer 0 from adam to publisher --arg 'Some "update"' --burn-cap 0.002
~~~~
~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 19611 units (will add 100 for safety)
Estimated storage: 2 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'oofkDT4MZQHqCeGeBYspwbTAu8kRooczZK7NdoswLa2HZJHQ5tG'
Waiting for the operation to be included...
Operation found in block: BKwCsSaRGzVAHYxnqDPitDxUJU8vEezLcUjNPPU9n4i8rxEgMpi (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
    Fee to the baker: ꜩ0.002241
    Expected counter: 32831
    Gas limit: 19711
    Storage limit: 22 bytes
    Balance updates:
      tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx .............. -ꜩ0.002241
      fees(tz3Q67aMz7gSMiQRcW729sXSfuMtkyAHYfqc,1160) ... +ꜩ0.002241
    Transaction:
      Amount: ꜩ0
      From: tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx
      To: KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2
      Parameter: (Some "update")
      This transaction was successfully applied
      Updated storage:
        (Pair 0x00000fb47b79f9e09a7078c52738196d68f542ec69d2 "update")
      Storage size: 519 bytes
      Paid storage size diff: 2 bytes
      Consumed gas: 19611
      Balance updates:
        tz1M5538RTnMHsXgph8nQB7bke1y1gbDBXEx ... -ꜩ0.002

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for oofkDT4MZQHqCeGeBYspwbTAu8kRooczZK7NdoswLa2HZJHQ5tG to be included --confirmations 30 --branch BKnM5rJBttX4V6kUCca98wJAKRMuFZDpHFkmyejhNdNZU3RTijp
and/or an external block explorer.
~~~~

When bob calls the contract to update the storage, the call fails because bob isn't the specified publisher:

~~~~
tezos-client transfer 0 from bob to publisher --arg 'Some "update"' --burn-cap 0.002
~~~~
~~~~
Node is bootstrapped, ready for injecting operations.
This simulation failed:
  Manager signed operations:
    From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
    Fee to the baker: ꜩ0
    Expected counter: 32826
    Gas limit: 800000
    Storage limit: 600000 bytes
    Transaction:
      Amount: ꜩ0
      From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
      To: KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2
      Parameter: (Some "update")
      This operation FAILED.

Runtime error in contract KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2:
  01: { parameter (option string) ;
  02:   storage (pair :storage (address %publisher) (string %data)) ;
  03:   code { DUP ;
  04:          DIP { CDR @storage_slash_1 } ;
  05:          CAR @param_slash_2 ;
  06:          DUP @param ;
  07:          IF_NONE
  08:            { PUSH mutez 1000000 ;
  09:              AMOUNT ;
  10:              COMPARE ;
  11:              LT ;
  12:              IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  13:                 { { DIP { DUP @storage } ; SWAP } ; NIL operation ; PAIR } }
  14:            { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  15:              CAR %publisher ;
  16:              SENDER ;
  17:              COMPARE ;
  18:              NEQ ;
  19:              IF { PUSH string "Cannot authenticate." ; FAILWITH }
  20:                 { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  21:                   CAR %publisher ;
  22:                   { DIP { DUP @p } ; SWAP } ;
  23:                   SWAP ;
  24:                   PAIR %publisher %data ;
  25:                   NIL operation ;
  26:                   PAIR } ;
  27:              DIP { DROP } } ;
  28:          DIP { DROP ; DROP } } }
At line 19 characters 55 to 63,
script reached FAILWITH instruction
with "Cannot authenticate."
Fatal error:
  transfer simulation failed
~~~~

# Call to query data

When the input data is *None*, it is a data query, and the contract checks that transfer amount is no less than 1tz. When the amount is less than 1tz, a runtime error occurs:

~~~~
tezos-client transfer 0 from bob to publisher --arg 'None' --burn-cap 0.002
~~~~
~~~~
Node is bootstrapped, ready for injecting operations.
This simulation failed:
  Manager signed operations:
    From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
    Fee to the baker: ꜩ0
    Expected counter: 32826
    Gas limit: 800000
    Storage limit: 600000 bytes
    Transaction:
      Amount: ꜩ0
      From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
      To: KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2
      Parameter: None
      This operation FAILED.

Runtime error in contract KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2:
  01: { parameter (option string) ;
  02:   storage (pair :storage (address %publisher) (string %data)) ;
  03:   code { DUP ;
  04:          DIP { CDR @storage_slash_1 } ;
  05:          CAR @param_slash_2 ;
  06:          DUP @param ;
  07:          IF_NONE
  08:            { PUSH mutez 1000000 ;
  09:              AMOUNT ;
  10:              COMPARE ;
  11:              LT ;
  12:              IF { PUSH string "Not enough money, queries cost 1 tez." ; FAILWITH }
  13:                 { { DIP { DUP @storage } ; SWAP } ; NIL operation ; PAIR } }
  14:            { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  15:              CAR %publisher ;
  16:              SENDER ;
  17:              COMPARE ;
  18:              NEQ ;
  19:              IF { PUSH string "Cannot authenticate." ; FAILWITH }
  20:                 { { DIP { DIP { DUP @storage } ; SWAP } ; SWAP } ;
  21:                   CAR %publisher ;
  22:                   { DIP { DUP @p } ; SWAP } ;
  23:                   SWAP ;
  24:                   PAIR %publisher %data ;
  25:                   NIL operation ;
  26:                   PAIR } ;
  27:              DIP { DROP } } ;
  28:          DIP { DROP ; DROP } } }
At line 12 characters 72 to 80,
script reached FAILWITH instruction
with "Not enough money, queries cost 1 tez."
Fatal error:
  transfer simulation failed
~~~~

When the amount is no less than 1tz, the call is successful:

~~~~
tezos-client transfer 1 from bob to publisher --arg 'None' --burn-cap 0.002
~~~~
~~~~
Node is bootstrapped, ready for injecting operations.
Estimated gas: 19482 units (will add 100 for safety)
Estimated storage: no bytes added
Operation successfully injected in the node.
Operation hash is 'ong5LGTB958ErYi3aeXTRTYbHUbbKPkhJtMy4eH3UPzqT1P5Ebi'
Waiting for the operation to be included...
Operation found in block: BMQEjBUCzkKzNn9wBt5g9FRdNhdbgDofodhf1qTUkLmNiPbMYZa (pass: 3, offset: 0)
This sequence of operations was run:
  Manager signed operations:
    From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
    Fee to the baker: ꜩ0.002219
    Expected counter: 32826
    Gas limit: 19582
    Storage limit: 0 bytes
    Balance updates:
      tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E .............. -ꜩ0.002219
      fees(tz1boot1pK9h2BVGXdyvfQSv8kd1LQM6H889,1160) ... +ꜩ0.002219
    Transaction:
      Amount: ꜩ1
      From: tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E
      To: KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2
      Parameter: None
      This transaction was successfully applied
      Updated storage:
        (Pair 0x00000fb47b79f9e09a7078c52738196d68f542ec69d2 "update")
      Storage size: 519 bytes
      Consumed gas: 19482
      Balance updates:
        tz1WGhT231BgqK7CrjbMB5xDsbdDSBJZiw5E ... -ꜩ1
        KT1UHgGu47CmP3MbBWRVBh1MyLXQuaEUUUc2 ... +ꜩ1

The operation has only been included 0 blocks ago.
We recommend to wait more.
Use command
  tezos-client wait for ong5LGTB958ErYi3aeXTRTYbHUbbKPkhJtMy4eH3UPzqT1P5Ebi to be included --confirmations 30 --branch BLTusHoy24S2S4NmV55hKWb4mMZoouv66UrFy18cDU5rECDGbef
and/or an external block explorer.
~~~~

One can think of the query function as a donation channel, because the audience can access the data without paying. One can ask the tezos-client the contract storage with the following command: 

```tezos-client get script storage for [contract address/alias]```