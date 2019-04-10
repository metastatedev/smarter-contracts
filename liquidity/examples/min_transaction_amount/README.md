This contract checks that an incoming amount of tz is above a certain amount before accepting the amount.  

In this contract the storage is *the minimum amount of tz the contract will accept*.  The parameter is *unit*.

To verify that the script only let transfers that are above or equal to the specified amount to go through:

(1) compile the min_transaction_amount.liq to .tz (by running **liquidity min_transaction_amount.liq**)

(2) typecheck the script with 

**tezos-client typecheck script [path to]/min_transaction_amount.tz**

(3) run the tezos-client with the *run script* command.  Here is an excerpt of the command details from [this link](https://tezos.gitlab.io/alphanet/api/cli-commands.html#client-manual):

-----------------------------------------------------

run script ***src*** on storage ***storage*** and input ***storage*** [--trace-stack] [--amount <amount>] [-q --no-print-source]  

Ask the node to run a script.  

***src***: source script  
  Can be a script name, a file or a raw script literal. If the parameter is
  not the name of an existing script, the client will look for a file
  containing a script, and if it does not exist, the argument will be read as
  a raw script.  
  Use 'alias:name', 'file:path' or 'text:literal' to disable autodetect.  
***storage***: the storage data  
***storage***: the input data  
**--trace-stack**: show the stack after each step  
**--amount <amount>**: amount of the transfer in ꜩ  
  Defaults to `0.05`.  
**-q --no-print-source**: don't print the source code  
  If an error is encountered, the client will print the contract's source
  code by default.  
  This option disables this behaviour.  

-------------------------------------------------------

The storage or input data have to be in a specific format.  See [this](https://github.com/cryptiumlabs/smarter-contracts/blob/master/liquidity/examples/tezos-clients-data-format.md).

For this contract, the *storage data* is the storage, i.e., the minimum amount it is going to accept.  The *input data* is the parameter of the contract, which is unit.  The *storage data* you pass in has to be an integer.  The integer represents 1/1000000 of 1tz.  That is, 1tz in the liquidity language translates to 1000000 in the *storage data* parameter.  However, the **--amount** option you pass in is in tz!    

If this contract works properly, a transfer can only go through if the transfer amount (passed in with the --amount option) is greater than the storage data.

You can see the script working, with the specified amount of 10tz, by passing in an amount above and below 10 tz respectively:

### When transfer amount is higher than the required amount

**tezos-client run script [path to]/min_transaction_amount.tz on storage '10000000' and input Unit --trace-stack --amount '11.0'**  

The **--trace-stack** option shows the stack operations.  The tezos-client ran the script without problem, because 11tz is larger than 10 tz.  The output:

storage  
  10000000  
emitted operations      
  
trace  
  - location: 6 (remaining gas: 399373 units remaining)
    [ (Pair Unit 10000000)       ]
  - location: 7 (remaining gas: 399370 units remaining)
    [ (Pair Unit 10000000)  
      (Pair Unit 10000000)       ]
  - location: 10 (remaining gas: 399364 units remaining)
    [ 10000000          @min_amount_slash_1 ]
  - location: 9 (remaining gas: 399363 units remaining)
    [ 10000000          @min_amount_slash_1 ]
  - location: 8 (remaining gas: 399363 units remaining)
    [ (Pair Unit 10000000)  
      10000000          @min_amount_slash_1 ]
  - location: 11 (remaining gas: 399360 units remaining)
    [ Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 15 (remaining gas: 399353 units remaining)
    [ 10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 14 (remaining gas: 399352 units remaining)
    [ 10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 13 (remaining gas: 399352 units remaining)
    [ Unit      @__slash_2
      10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 16 (remaining gas: 399349 units remaining)
    [ 10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: -1 (remaining gas: 399348 units remaining)
    [ 10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 17 (remaining gas: 399345 units remaining)
    [ 11000000          @amount
      10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 18 (remaining gas: 399342 units remaining)
    [ 1  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 19 (remaining gas: 399339 units remaining)
    [ False  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 27 (remaining gas: 399332 units remaining)
    [ Unit  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 26 (remaining gas: 399331 units remaining)
    [ Unit  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 28 (remaining gas: 399328 units remaining)
    [ Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 29 (remaining gas: 399325 units remaining)
    [ 10000000          @min_amount_slash_1 ]
  - location: 30 (remaining gas: 399319 units remaining)
    [ {}  
      10000000          @min_amount_slash_1 ]
  - location: 32 (remaining gas: 399311 units remaining)
    [ (Pair {} 10000000)         ]
  - location: -1 (remaining gas: 399310 units remaining)
    [ (Pair {} 10000000)         ]

### When transfer amount is lower than the required amount.

**tezos-client run script [path to]/min_transaction_amount.tz on storage '10000000' and input Unit --trace-stack --amount '9.00'**  

Because the transfer amount is less than the required amount, a runtime error occur as desired.  The output:

Runtime error in contract KT1BEqzn5Wx8uJrZNvuS9DVHmLvG9td3fDLi:  

  01: parameter unit;  
  02: storage mutez;  
  03: code { DUP ;  
  04:        DIP { CDR @min_amount_slash_1 } ;  
  05:        CAR @__slash_2 ;  
  06:        DUUP @min_amount ;  
  07:        AMOUNT ;  
  08:        COMPARE ;  
  09:        LT ;  
  10:        IF { PUSH string "Amount is less than the required minimum." ; FAILWITH }  
  11:           { UNIT } ;  
  12:        DROP ;  
  13:        DROP ;  
  14:        NIL operation ;  
  15:        PAIR };  
  16:   
At line 10 characters 70 to 78,  
script reached FAILWITH instruction  
with "Amount is less than the required minimum."  
trace  
  - location: 6 (remaining gas: 399373 units remaining)
    [ (Pair Unit 10000000)       ]
  - location: 7 (remaining gas: 399370 units remaining)
    [ (Pair Unit 10000000)  
      (Pair Unit 10000000)       ]
  - location: 10 (remaining gas: 399364 units remaining)
    [ 10000000          @min_amount_slash_1 ]
  - location: 9 (remaining gas: 399363 units remaining)
    [ 10000000          @min_amount_slash_1 ]
  - location: 8 (remaining gas: 399363 units remaining)
    [ (Pair Unit 10000000)  
      10000000          @min_amount_slash_1 ]
  - location: 11 (remaining gas: 399360 units remaining)
    [ Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 15 (remaining gas: 399353 units remaining)
    [ 10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 14 (remaining gas: 399352 units remaining)
    [ 10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 13 (remaining gas: 399352 units remaining)
    [ Unit      @__slash_2
      10000000          @min_amount
      10000000          @min_amount_slash_1 ]
  - location: 16 (remaining gas: 399349 units remaining)
    [ 10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: -1 (remaining gas: 399348 units remaining)
    [ 10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 17 (remaining gas: 399345 units remaining)
    [ 9000000   @amount
      10000000          @min_amount
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 18 (remaining gas: 399342 units remaining)
    [ -1  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 19 (remaining gas: 399339 units remaining)
    [ True  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
  - location: 22 (remaining gas: 399332 units remaining)
    [ "Amount is less than the required minimum."  
      Unit      @__slash_2
      10000000          @min_amount_slash_1 ]
Fatal error:
  error running script
