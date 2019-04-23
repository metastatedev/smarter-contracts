type storage = unit

(* Spend fund. *)
let%entry spendFund (toAddress,toAmount) _ =
  let op =
    Account.transfer ~dest:toAddress ~amount:toAmount in
  [op], ()

(* Change delegate. *)
let%entry change_delegate (new_del : key_hash) () =
  let op = Contract.set_delegate (Some new_del) in
  [op], ()

(* Remove delegate. *)
let%entry remove_delegate () () =
  let op = Contract.set_delegate None in
  [op], ()