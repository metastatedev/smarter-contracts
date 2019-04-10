(* A contract that contains a map-based queue. *)
type storage = {
  big : (int, string) big_map;
  last_key : int;
  nothing : unit
}

(* let%init storage = {
    BigMap [0, ""];
    0;
    ()
} *)

(* The parameter is a string option. *)
let%entry main (param : string option) current_queue =
  let l_key = current_queue.last_key in
    let new_key = l_key + 1 in
      let new_queue = match param with
        | None -> 
          if l_key = 0 then
            current_queue
          else {big = (Map.remove l_key current_queue.big) ; last_key = (l_key - 1) ; nothing = () }
        | Some v -> {big = (Map.add new_key v current_queue.big); last_key = new_key; nothing = ()}
      in
        [], new_queue
