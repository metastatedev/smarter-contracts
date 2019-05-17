(* Token contract signature. *)
contract type NatContract = sig
  type storage
  val%entry main : nat -> _
end

contract type NatNatContract = sig
  type storage
  val%entry main : nat * nat -> _
end

contract type Token = sig

  type account = {
    balance : nat;
    allowances : (address, nat) map;
  }

  type storage = {
    accounts : (address, account) big_map;
    version : nat; (* version of token standard *)
    totalSupply : nat;
    decimals : nat;
    name : string;
    symbol : string;
    owner : address;
  }

  val%entry transfer : (address * nat) -> _
  val%entry approve : (address * nat) -> _
  val%entry transferFrom : (address * address * nat) -> _
  val%entry balanceOf : (address * NatContract.instance) -> _
  val%entry allowance : (address * address * NatNatContract.instance) -> _
  val%entry createAccount : (address * nat) -> _
  val%entry createAccounts : (address * nat) list -> _

end
(* End of signature. *)

type storage = {
  offered_amount : nat;
  accepted_amount : nat;
  offered_token : Token.instance;
  accepted_token : Token.instance;
}

let%entry main (key, signature)  storage =
  let amount = 0tz in
    let accepter = Current.source () in
      let offerer_hash = Crypto.hash_key key in
        let offerer = Contract.address (Account.default offerer_hash) in
          if Crypto.check key signature (Bytes.pack (Contract.self ())) then
            let opa = storage.offered_token.transferFrom (offerer,accepter,storage.offered_amount) ~amount in
              let opb = storage.accepted_token.transferFrom (accepter,offerer,storage.accepted_amount) ~amount in
                [opa;opb], storage
          else 
            failwith "Wrong signature"
        