## Liquidity Contracts

[Liquidity](http://www.liquidity-lang.org/) required.

Other example Liquidity contracts can be found [here](https://github.com/OCamlPro/liquidity/tree/next/tests/others).

To **deploy** a contract, follow the instructions on [Tezos](https://tezos.gitlab.io/alphanet/introduction/howtouse.html#originated-accounts-and-contracts) or [Liquidity](http://www.liquidity-lang.org/doc/usage/index.html#deploying-a-contract).

The deployment should originate a new contract address that starts with *KT1*.

To **call** a contract, follow the instructions on [Liquidity](http://www.liquidity-lang.org/doc/usage/index.html#calling-a-contract).  When successful, the call should return: 'Successful call to contract [the originated account address (from the contract deployment)] in operation [some operation hash].'
