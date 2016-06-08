open Spotlib.Spot
open Ini_types

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

let options t sec =
  match List.find t ~f:(fun (sec', _) -> sec = sec') with
  | Some (_, opts) -> Some opts
  | None -> None

let mem_section t sec =
  is_some @@ options t sec

let get t sec opt =
  match options t sec with
  | Some opts ->
    begin match List.find opts ~f:(fun (k, _) -> k = opt) with
    | Some (_, v) -> Some v
    | None -> None
    end
  | None -> None

let mem_option t sec opt =
  is_some @@ get t sec opt

let iter (t : t) sec f =
  match options t sec with
  | Some opts -> List.iter opts ~f:(fun (k, v) -> f k v)
  | None -> ()

let split ?(on=',') s =
  List.map (String.split ~on s)
    ~f:(fun s' -> String.strip s' ~drop:(fun c -> c = ' '))
