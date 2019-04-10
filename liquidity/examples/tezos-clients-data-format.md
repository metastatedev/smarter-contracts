# Tezos client data format documentation

When running tezos-client commands that require data input, the data input have to be in a specific format.  This documentation contains some translations (more will be added over time), and a guide to translate the Liquidity language data type to the required data format for the tezos-client.

For example, the **run script** command requires input of storage/input data:

From [the client manual](https://tezos.gitlab.io/alphanet/api/cli-commands.html#client-manual):

------------------------------------------------------------------------------
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
  
--------------------------------------------------------------------------------
The *storage data* and the *input data* are in a specific format.  Documentation regarding the required format seems missing.  Below are some translations.

## Translations

|Data Type | Liquidity Syntax | Tezos Client Format |
| --- | --- | ----------- |
| tez | 1tz | '1000000' |
| string list | ["x" ; "y"] | '{ "x" ; "y" }' |

## Guide to translate other datatypes

Here I provide a way to **translate between the [liquidity data format](http://www.liquidity-lang.org/doc/reference/liquidity.html#basic-types-and-values) and the required format**:

(1) Add the storage initialization code (tradition is below the storage type declaration) to a .liq file:

let%init storage = 10tz

Make sure the storage type declared above is the same as the initial storage.  E.g., the above specifies that the initial storage is *10tz*, of type *tez*.  Consult the [liquidity documentation](http://www.liquidity-lang.org/doc/reference/liquidity.html#basic-types-and-values) for the specification of each data type.

(2) Compile the .liq file:

**liquidity [path to]/filename.liq**

The result of the command should look like this:

*Constant initial storage generated in "[path to]/filename.init.tz"  
File "[path to]/filename.tz" generated  
If tezos is compiled, you may want to typecheck with:  
  tezos-client typecheck script [path to]/filename.tz*  
  
(3) View the .init.tz file.  In the above case, the content is:
10000000

The content wrapped in single quotes is what you should pass in to the tezos-client. 
