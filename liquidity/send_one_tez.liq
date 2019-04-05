(*A contract that sends 1 tez to anyone who asks. *)

type storage = unit 

(* Initialize storage to (). *)
let%init storage = ()

let%entry main
      (key : key_hash)
      _storage =
   let op = Account.transfer ~dest:key ~amount:1tz in
   ( [op], () )