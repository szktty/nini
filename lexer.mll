{
open Spotlib.Spot
open Lexing
open Parser

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = pos.pos_cnum;
               pos_lnum = pos.pos_lnum + 1
    }

let revise_pos pos lexbuf =
  { pos with pos_bol = pos.pos_cnum - lexbuf.lex_curr_p.pos_bol + 1 }

let start_pos lexbuf =
  revise_pos (lexeme_start_p lexbuf) lexbuf

let end_pos lexbuf =
  revise_pos (lexeme_end_p lexbuf) lexbuf

let syntax_error lexbuf msg =
  { Ini_type.pos = start_pos lexbuf; error = msg }

let skip_lines lexbuf =
  let rec skip = function
    | [] -> ()
    | '\r' :: '\n' :: tl -> next_line lexbuf; skip tl
    | '\r' :: tl -> next_line lexbuf; skip tl
    | '\n' :: tl -> next_line lexbuf; skip tl
    | _ :: tl -> next_line lexbuf; skip tl
  in
  skip @@ String.to_list @@ lexeme lexbuf
}

let word = ['a'-'z' 'A'-'Z' '0'-'9' '_' '.' '-']+
let comment = ';' [^'\r' '\n']*
let space = [' ' '\t']
let break = '\r' | '\n' | "\r\n"
let empty = break (space* break)+

rule main =
  parse
  | empty { skip_lines lexbuf; BREAK }
  | break { next_line lexbuf; BREAK }
  | "[" { LBRACK }
  | "]" { RBRACK }
  | "=" { EQ }
  | space+ as s { BLANK s }
  | word as s { WORD s }
  | comment as s { COMMENT s }
  | _ as s { VALUE (Char.to_string s) }
  | eof { EOF }

