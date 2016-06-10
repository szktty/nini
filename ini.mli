open Spotlib.Spot

val parse_file : string -> (Config.t, Lexing.position) Result.t
val parse_string : string -> (Config.t, Lexing.position) Result.t
