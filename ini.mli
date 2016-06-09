open Spotlib.Spot

type t = Ini_types.t
type error = Ini_types.error

val parse_file : string -> (t, error) Result.t option
val parse_file_exn : string -> (t, error) Result.t
val parse_string : string -> (t, error) Result.t

val sections : t -> (string * (string * string) list) list
val params : t -> section:string -> (string * string) list
val exists : t -> ?param:string -> section:string -> bool
val get : t -> section:string -> param:string -> string option
val get_exn : t -> section:string -> param:string -> string

val iter : t -> f:(string -> string -> string -> unit) -> unit
val find : t -> f:(string -> string -> string -> bool) -> (string * string * string) option
val find_exn : t -> f:(string -> string -> string -> bool) -> (string * string * string)
val fold_left : t -> init:'a -> f:('a -> string -> string -> string -> 'a) -> 'a

val split_value : ?on:string -> string -> string list
