(* A contract that publishes data securely. *)

type storage = {
  key : key;
  message : string
}

let%entry main (param : (string option)) storage =
  match param with
    | None -> 
      if Current.amount() < 1tz then
        Current.failwith "Not enough money, queries cost 1 tez."
      else
        ([], storage)
    | Some p ->
      if Current.sender () <> storage.key then
          failwith "Cannot authenticate."
        else 
          let new_data = {
            key = storage.key;
            message = p.string
            }
          in
            ([], new_data)
