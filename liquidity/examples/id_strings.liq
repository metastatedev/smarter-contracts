(* Identity contract for strings. *)

type storage = unit 

let%entry main
      (_parameter : string)
      storage =
   ( [], storage )

(* Initialize storage to (). *)
let%init storage = ()
