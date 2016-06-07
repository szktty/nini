open Spotlib.Spot

type t

type item = {
  key : string;
  value : string;
}

type section = {
  name : string;
  items : item list;
}

type error = {
  pos : Lexing.position option;
  reason : string;
}

val parse : string -> (t, error) Result.t

val sections : t -> section list
val options : t -> section:string -> item list option
val options_exn : t -> section:string -> item list
val mem : t -> ?option:string -> section:string -> bool
val get : t -> section:string -> option:string -> string option
val get_exn : t -> section:string -> option:string -> string

val iter : t -> ?section:string -> f:(string -> string -> unit) -> unit
val map : t -> ?section:string -> f:(string -> string -> 'a) -> 'a list
val find : t -> ?section:string -> f:(string -> string -> bool) -> string option
val find_exn : t -> ?section:string -> f:(string -> string -> bool) -> string
val find_map : t -> ?section:string -> f:(string -> string -> 'a) -> 'a option
val find_map_exn : t -> ?section:string -> f:(string -> string -> 'a) -> 'a
