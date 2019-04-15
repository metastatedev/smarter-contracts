(* A contract that contains a map-based queue. 
 * If the parameter is None, then the first item on the queue is removed.  
 * If the parameter is Some string, then that string is added to the end of the queue. *)

type storage = {
  map : (int, string) map;
  first_key : int;
  last_key : int;
  nothing : unit
}

(* Initialize storage to an empty queue. *)
let%init storage = {
  map = Map [0, ""];
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
                map = (Map.remove f_key current_queue.map) ;
                first_key = (if new_f_key > l_key + 1 then f_key else new_f_key) ; 
                last_key = l_key ;
                nothing = () }
            | Some v -> {
                map = (Map.add new_l_key v current_queue.map); 
                first_key = (if f_key = 0 then new_f_key else f_key);
                last_key = new_l_key ; 
                nothing = ()}
          in
            [], new_queue
