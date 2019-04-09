(* A contract that reverses a string list. *)

type storage = string list

(* Initialize storage. *)
let%init storage = ["x"; "y";"z"]

(* The parameter is the string list. *)
let%entry main
      (input_list : string list)
      _storage =
   let output_list = List.rev input_list in       
   ( [], output_list )