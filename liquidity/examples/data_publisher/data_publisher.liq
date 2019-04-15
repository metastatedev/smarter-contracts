(* A contract that publishes data securely.
 * When a data publisher wishes to share/update data, 
 they publish a public key and sign the data to a given contract. 
 * The signature is checked to ensure that no one else can write to the contract. 
 * Users can make queries at a price of 1 tez, paid to the data supplier/verifier. 
 * If the parameter is None, then it's a data query.  
 * Otherwise, the data is updated if the data is supplied along with the authentic key. *)

type storage = {
  key : key;
  signature : signature;
  counter : nat;
  message : string;
  nothing : unit
}

let%entry main (param : (key, signature, nat, string, unit) option) current_storage =
  match None with
    | None -> 
      ([],current_storage)
    | Some s ->
      let bytes = Bytes.pack s.message in
        if not (Crypto.check s.key s.signature bytes) then
          failwith "Wrong signature"
        else 
          let new_data = 
            {key = s.key;
            signature = s.signature;
            counter = s.counter + 1p;
            message = s.message;
            nothing = ()}
          in
            ([], new_data)
