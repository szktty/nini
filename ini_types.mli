type item = {
  key : string;
  value : string;
}

type section = {
  name : string;
  items : item list;
}

type error = {
  pos : Lexing.position option;
  reason : string;
}

type t = section list
