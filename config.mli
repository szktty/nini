type section = {
  name : string;
  params : (string * string) list;
}

type t = section list

val sections : t -> (string * (string * string) list) list
val params : t -> section:string -> (string * string) list
val exists : ?param:string -> t -> section:string -> bool
val get : t -> section:string -> param:string -> string option
val get_exn : t -> section:string -> param:string -> string

val iter : t -> f:(string -> string -> string -> unit) -> unit
val find : t -> f:(string -> string -> string -> bool) -> (string * string * string) option
val find_exn : t -> f:(string -> string -> string -> bool) -> (string * string * string)
val fold_left : t -> init:'a -> f:('a -> string -> string -> string -> 'a) -> 'a

val split_value : ?on:char -> string -> string list
