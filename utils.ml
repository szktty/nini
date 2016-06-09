open Spotlib.Spot

let string_of_char c =
  String.make 1 c

let is_some = function
  | None -> false
  | Some _ -> true

let is_none opt = not & is_some opt
