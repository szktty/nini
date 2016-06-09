type t

type error = {
  pos : Lexing.position option;
  reason : string;
}
