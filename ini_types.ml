type section = {
  name : string;
  params : (string * string) list;
}

type error = {
  pos : Lexing.position option;
  reason : string;
}

type t = section list
