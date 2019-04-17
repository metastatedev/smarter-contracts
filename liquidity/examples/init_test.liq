(* Identity contract for strings. *)

type storage = address set

let%init storage = Set [Current.source ()]

let%entry main
      (_parameter : string)
      storage =
   ( [], storage )

