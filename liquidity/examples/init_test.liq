(* Identity contract for strings. *)

type storage = address set

(* let init_add = Current.source ()  *)
  
let%init storage = Set [KT1LLcCCB9Fr1hrkGzfdiJ9u3ZajbdckBFrF;KT1LLcCCB9Fr1hrkGzfdiJ9u3ZajbdckBFrF]

let%entry main
      (_parameter : string)
      storage =
   ( [], storage )

