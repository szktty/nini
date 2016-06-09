open Spotlib.Spot
open Ini_types

type t = Ini_types.t
type section = Ini_types.section
type param = Ini_types.param
type error = Ini_types.error

let parse lexbuf file =
  lexbuf.Lexing.lex_curr_p <-
    { lexbuf.Lexing.lex_curr_p with Lexing.pos_fname = file };
  try begin
    `Ok (Parser.main Lexer.main lexbuf)
  end with
  | Lexer.Error err -> `Error err
  | Parser.Error -> `Error {
      pos = Some lexbuf.lex_curr_p;
      reason = "invalid syntax";
    }

let parse_string s =
  parse (Lexing.from_string s)

let parse_file file =
  let inx = open_in file in
  parse (Lexing.from_channel inx)

let sections t =
  List.map List.hd t

let params t ~section =
  match List.find_opt (fun sec' -> section = sec'.name) t with
  | None -> []
  | Some { name = _; params } -> params

let get t ~section ~param =
  let params' = params t ~section in
  match List.find_opt (fun param' -> param = param'.key) params' with
  | Some param -> Some param.value
  | None -> None

let get_exn t ~section ~param =
  Option.from_Some & get t ~section ~param

let exists ?param t ~section =
  match param with
  | None -> 0 = (List.length & params t ~section)
  | Some param -> Utils.is_some & get t ~section ~param

let iter t ~f =
  List.iter (fun sec ->
               List.iter (fun param -> f sec param.key param.value)
                 sec.params)
    t.sections

let split_value ?(on=',') s =
  List.map (String.split ~on s)
    ~f:(fun s' -> String.strip s' ~drop:(fun c -> c = ' '))
