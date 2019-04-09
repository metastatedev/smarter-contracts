(* A contract that rejects payments below the specified amount. *)

type storage = tez

(* The parameter is (). *)
let%entry main
      ()
      min_amount =
   if Current.amount () < min_amount then
      Current.failwith ("Amount is less than the required minimum.");
   ( [], min_amount )