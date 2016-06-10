open Spotlib.Spot

type section = {
  name : string;
  params : (string * string) list;
}

type t = section list

let sections conf =
  List.map (fun sec -> (sec.name, sec.params))  conf

let params conf ~section =
  match List.find_opt (fun sec' -> section = sec'.name) conf with
  | None -> []
  | Some { name = _; params } -> params

let get conf ~section ~param =
  let params' = params conf ~section in
  match List.find_opt (fun (k, _) -> param = k) params' with
  | Some (_, v) -> Some v
  | None -> None

let get_exn conf ~section ~param =
  Option.from_Some & get conf ~section ~param

let exists ?param conf ~section =
  match param with
  | None -> 0 = (List.length & params conf ~section)
  | Some param -> Utils.is_some & get conf ~section ~param

let iter conf ~f =
  List.iter
    (fun sec -> List.iter (fun (k, v) -> f sec.name k v) sec.params)
    conf

let find conf ~f =
  List.fold_left
    (fun res sec ->
       match res with
       | Some param -> Some param
       | None ->
         match List.find_opt (fun (k, v) -> f sec.name k v) sec.params with
         | None -> None
         | Some (k, v) -> Some (sec.name, k, v))
    None conf

let find_exn conf ~f =
  Option.from_Some & find conf ~f

let fold_left conf ~init ~f =
  List.fold_left
    (fun accu sec ->
       List.fold_left (fun accu (k, v) -> f accu sec.name k v) accu sec.params)
    init conf

let split_value ?(on=',') s =
  List.map String.trim (String.split (fun c -> c = on) s)
