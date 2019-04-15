(* A contract that contains a map-based queue. 
 * If the parameter is None, then the first item on the queue is removed.  
 * If the parameter is Some string, then that string is added to the end of the queue. 
 * big map, which is optimized for a large database, is used in this version. *)

type storage = {
  big : (int, string) big_map;
  first_key : int;
  last_key : int;
  nothing : unit
}

(* Initialize storage to an empty queue. *)
let%init storage = {
  big = BigMap [0, ""];
  first_key = 0;
  last_key = 0;
  nothing = ()
}

let%entry main (param : string option) current_queue =
  let l_key = current_queue.last_key in
    let f_key = current_queue.first_key in
      let new_l_key = l_key + 1 in
        let new_f_key = f_key + 1 in
          let new_queue = match param with
            | None -> 
              if l_key = 0 then
                current_queue
              else { 
                big = (Map.remove f_key current_queue.big) ; 
                first_key = (if new_f_key > l_key + 1 then f_key else new_f_key) ; 
                last_key = l_key ;
                nothing = () }
            | Some v -> {
                big = (Map.add new_l_key v current_queue.big); 
                first_key = (if f_key = 0 then new_f_key else f_key);
                last_key = new_l_key ; 
                nothing = ()}
          in
            [], new_queue
