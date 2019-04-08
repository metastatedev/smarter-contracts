(* A contract that rejects payments below the specified amount. *)

type storage = tez

(* The parameter is (). *)
let%entry main
      ()
      minAmount =
   if Current.amount () < minAmount then
         failwith ("Amount is less than minimum required amount.")
   else
   ( [], minAmount )