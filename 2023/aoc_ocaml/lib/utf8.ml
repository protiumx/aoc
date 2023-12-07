let is_alpha = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false

let is_digit = function '0' .. '9' -> true | _ -> false

let get_chars s =
  s |> String.to_seq |> List.of_seq
