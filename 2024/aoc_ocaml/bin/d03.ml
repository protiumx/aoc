open Core

let instructions = AOC.get_input 3
let zero = int_of_char '0'

let rec parse_number ?(acc = None) s =
  match s with
  | d :: xs when Char.is_digit d ->
      let acc = Option.value acc ~default:0 in
      parse_number xs ~acc:(Some ((acc * 10) + int_of_char d - zero))
  | _ -> (acc, s)

let rec parse_mul ?(valid = false) ?(a = None) ?(b = None) s =
  match s with
  | '(' :: xs ->
      let a, xs = parse_number xs in
      parse_mul xs ~valid:true ~a
  | ',' :: xs when valid && Option.is_some a ->
      let b, xs = parse_number xs in
      parse_mul xs ~valid ~a ~b
  | ')' :: xs when valid && Option.is_some b -> (xs, Some (Option.value_exn a * Option.value_exn b))
  | _ -> (s, None)

let rec parse ?(acc = 0) ?(cond = false) ?(do' = true) s =
  match s with
  | [] -> acc
  | 'd' :: 'o' :: '(' :: ')' :: xs when cond -> parse xs ~cond ~acc ~do':true
  | 'd' :: 'o' :: 'n' :: '\'' :: 't' :: '(' :: ')' :: xs when cond -> parse xs ~cond ~acc ~do':false
  | 'm' :: 'u' :: 'l' :: xs when do' -> (
      match parse_mul xs with
      | s, Some n -> parse s ~cond ~do' ~acc:(acc + n)
      | s, None -> parse s ~cond ~do' ~acc)
  | _ :: xs -> parse xs ~cond ~do' ~acc

let part_1 = instructions |> String.to_list |> parse |> Fmt.pr "Part 1: %d@."
let part_2 = instructions |> String.to_list |> parse ~cond:true |> Fmt.pr "Part 2: %d@."

let () =
  part_1;
  part_2
