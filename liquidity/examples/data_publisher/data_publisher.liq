(* A contract that publishes data securely.
 * When a data publisher wishes to share/update data, 
 they publish a public key and sign the data to a given contract. 
 * The signature is checked to ensure that no one else can write to the contract. 
 * Users can make queries at a price of 1 tez, paid to the data supplier/verifier. 
 * If the parameter is None, then it's a data query.  
 * Otherwise, the data is updated if the data is supplied along with the authentic key. *)

type storage = {
  key : key;
  counter : nat;
  message : string
}

let %init storage = {
  key =edpku5LTYXxXKTjmzj9qtHR6TTYH1K6JU7bFe8MyJs6qabUs9kiZes;
  counter = 0p;
  message = "init"
}

type parameter = {
  signature : signature;
  string : string;
  number_of_op : nat
}

let%entry main (param : (parameter option)) storage =
  match param with
    | None -> 
      if Current.amount() < 1tz then
        Current.failwith "Not enough money, queries cost 1 tez."
      else
        ([], storage)
    | Some p ->
      let bytes = Bytes.pack p.string in
        if not (Crypto.check storage.key p.signature bytes) && p.number_of_op = storage.counter then
          failwith "Cannot authenticate."
        else 
          let new_data = {
            key = storage.key;
            counter = storage.counter + 1p;
            message = p.string
            }
          in
            ([], new_data)
