type storage = address

(* let%init storage = KT18ngTgjo1cbFYXNDEsRw1weEBGdKMLTF9C *)

(* Spend fund. *)
let%entry spendFund (toAddress,toAmount) owner =
  if Current.sender () <> owner then
    Current.failwith ("Only the owner can operate.", owner, Current.sender ())
  else
    let op = Account.transfer ~dest:toAddress ~amount:toAmount in
    [op], owner

(* Change delegate. *)
let%entry change_delegate (new_del : key_hash) owner =
  if Current.sender () <> owner then
    Current.failwith ("Only the owner can operate.")
  else
    let op = Contract.set_delegate (Some new_del) in
    [op], owner

(* Remove delegate. *)
let%entry remove_delegate () owner =
  if Current.sender () <> owner then
    Current.failwith ("Only the owner can operate.", owner, Current.sender ())
  else
    let op = Contract.set_delegate None in
    [op], owner

(* Change owner. *)
let%entry change_owner new_owner owner =
  if Current.sender () <> owner then
    Current.failwith ("Only the owner can initiate an operation.")
  else
    [], new_owner