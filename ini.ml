open Spotlib.Spot

let parse lexbuf file =
  lexbuf.Lexing.lex_curr_p <-
    { lexbuf.Lexing.lex_curr_p with Lexing.pos_fname = file };
  try begin
    `Ok (Parser.main Lexer.main lexbuf)
  end with
  | Parser.Error -> `Error lexbuf.lex_curr_p

let parse_string s =
  parse (Lexing.from_string s) ""

let parse_file file =
  let inx = open_in file in
  parse (Lexing.from_channel inx) file
