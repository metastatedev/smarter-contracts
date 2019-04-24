type storage = unit

contract type managerContract = sig
  type storage = address
  val%entry spendFund : address, tez -> _
  val%entry change_delegate : key_hash -> _
  val%entry remove_delegate : unit -> _
  val%entry change_owner : address -> _
end

let%entry main (addr : address) _ =
  begin match (Contract.at addr : managerContract.instance option) with
    | None -> failwith ("Cannot recover manager contract from:", addr)
    | Some _contract -> (*Contract.call*)
  end;
  [], ()
