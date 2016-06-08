%{
open Spotlib.Spot
open Ini_types

%}

%token EOF
%token LBRACK
%token RBRACK
%token EQ
%token BREAK
%token <string> BLANK
%token <string> WORD
%token <string> VALUE
%token <string> COMMENT

%start <Ini_types.t> main

%%

main:
  | BREAK EOF { [] }
  | sections_with_skip_lines EOF { $1 }
  | blank_line sections_with_skip_lines EOF { $2 }

term:
  | BREAK {}
  | EOF {}

blank_line:
  | BLANK term {}

skip_lines:
  | comment_line { [$1] }
  | skip_lines comment_line { $2 :: $1 }

comment_line:
  | COMMENT term { $1 }

sections_with_skip_lines:
  | sections { $1 }
  | skip_lines sections { $2 }

sections:
  | rev_sections { List.rev $1 }

rev_sections:
  | (* empty *) { [] }
  | rev_sections section { $2 :: $1 }

section:
  | title_part properties { { name = $1; items = $2 } }

title_part:
  | title term { $1 }
  | title BLANK term { $1 }
  | title term skip_lines { $1 }
  | title BLANK term skip_lines { $1 }

title:
  | LBRACK WORD RBRACK { $2 }

properties:
  | (* empty *) { [] }
  | property_with_skip_lines properties { $1 :: $2 }

property_with_skip_lines:
  | property { $1 }
  | property skip_lines { $1 }

property:
  | key_part EQ values term
  {
    let buf = Buffer.create 16 in
    List.iter (fun v -> Buffer.add_string buf v) $3;
    let s = String.trim (Buffer.contents buf) in
    { key = $1; value = s }
  }

key_part:
  | WORD { $1 }
  | WORD BLANK { $1 }
  | BLANK WORD { $1 }
  | BLANK WORD BLANK { $1 }

values:
  | rev_values { List.rev $1 }

rev_values:
  | single_value { [$1] }
  | rev_values single_value { $2 :: $1 }

single_value:
  | WORD { $1 }
  | VALUE { $1 }
  | BLANK { $1 }
  | COMMENT { $1 }
  | LBRACK { "[" }
  | RBRACK { "]" }
  | EQ { "=" }
