This contract reverses a given list.

In this contract the storage is the output string, of type string list. The parameter is the input string, of type string list.

To verify that the script reverses the list:

(1) compile reverse_list.liq to .tz (by running ```liquidity reverse_list.liq```)

(2) typecheck the script with

```tezos-client typecheck script [path to]/min_transaction_amount.tz```

(3) run a tezos-node in the local network.  Make sure it's bootstrapped.  See [this](http://tezos.gitlab.io/mainnet/introduction/howtouse.html#rpc-interface).

(4) run the tezos-client *run script* command as follows:

```tezos-client run script [path to]/reverse_list.tz on storage '{}' and input '{ "abc" ; "def" ; "x" ; "y" ; "z"}'```  

Here is an excerpt of the command details from [this link](https://tezos.gitlab.io/alphanet/api/cli-commands.html#client-manual):

-----------------------------------------------------------------------

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
```--trace-stack```: show the stack after each step  
```--amount <amount>```: amount of the transfer in ꜩ  
  Defaults to `0.05`.  
```-q --no-print-source```: don't print the source code  
  If an error is encountered, the client will print the contract's source
  code by default.  
  This option disables this behaviour.  

-----------------------------------------------------------------------------

The storage or input data have to be in a specific format.  See [this](https://github.com/cryptiumlabs/smarter-contracts/blob/master/liquidity/examples/tezos-clients-data-format.md).

For this contract, the *storage data* is the storage.  It is of type string list.  It will store the reversed list.  It can be an empty list initially.  The *input data* is the parameter of the contract, which is the input list, of type string list.      

If this contract works properly, the storage should be a reversed list of the input.

You can see the script working from the output being the reversed list:

```tezos-client run script [path to]/reverse_list.tz on storage '{}' and input '{ "abc" ; "def" ; "x" ; "y" ; "z"}'```  
~~~~
storage  
  { "z" ; "y" ; "x" ; "def" ; "abc" }  
emitted operations  
~~~~
