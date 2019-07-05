(* A contract that publishes data securely. *)

type storage = {
  publisher : address;
  data : bytes
}

let%entry main (param : string) storage =
  if (Crypto.sha512 (Bytes.pack param)) = storage.data then 
    if Current.amount() < 1tz then
      failwith "Not enough money, queries cost 1 tez."
    else 
      ([], storage)
  else if Current.sender () <> storage.publisher then
    failwith "Cannot authenticate."
  else 
    ([], storage.data <- Crypto.sha512 (Bytes.pack param))