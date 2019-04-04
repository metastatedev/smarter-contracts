(*Identity contract for strings. *)

type storage = unit 

let%entry main
      (_parameter : string)
      (storage : storage) =
   ( [], storage )

