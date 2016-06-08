open Spotlib.Spot
open Ini_types

val parse_file : string -> (t, error) Result.t option
val parse_file_exn : string -> (t, error) Result.t
val parse_string : string -> (t, error) Result.t

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
