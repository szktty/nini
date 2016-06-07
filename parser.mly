%{

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

%start <Ini.t> main

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
  | sections_rev { List.rev $1 }
  | skip_lines sections_rev { List.rev $2 }

sections_rev:
  | (* empty *) { [] }
  | sections_rev section { $2 :: $1 }

section:
  | title_part properties { ($1, $2) }

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
  | key_part EQ values_rev term
  { ($1, String.strip (String.concat (List.rev $3))) }

key_part:
  | WORD { $1 }
  | WORD BLANK { $1 }
  | BLANK WORD { $1 }
  | BLANK WORD BLANK { $1 }

values_rev:
  | single_value { [$1] }
  | values_rev single_value { $2 :: $1 }

single_value:
  | WORD { $1 }
  | VALUE { $1 }
  | BLANK { $1 }
  | COMMENT { $1 }
  | LBRACK { "[" }
  | RBRACK { "]" }
  | EQ { "=" }
