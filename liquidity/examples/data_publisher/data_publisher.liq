(* A contract that publishes data securely. *)

type storage = {
  publisher : address;
  data : string
}

let%entry main (param : (string option)) storage =
  match param with
    | None -> 
      if Current.amount() < 1tz then
        failwith "Not enough money, queries cost 1 tez."
      else
        ([], storage)
    | Some p ->
      if Current.sender () <> storage.publisher then
        failwith "Cannot authenticate."
      else 
        ([], storage.data <- p)