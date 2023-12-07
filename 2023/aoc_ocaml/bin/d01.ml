open Core

let part_1 =
  let lines = AOC.Files.read_lines "input/d01.in" in
  List.fold lines ~init:0 ~f:(fun acc line ->
      let chars = String.to_list line in
      let numbers = List.filter chars ~f:Char.is_digit in
      let number = Fmt.str "%c%c" (List.hd_exn numbers) (List.last_exn numbers) in
      acc + Int.of_string number)
  |> Fmt.pr "part 1: %d\n"

let numbers =
  [
    ("one", '1');
    ("two", '2');
    ("three", '3');
    ("four", '4');
    ("five", '5');
    ("six", '6');
    ("seven", '7');
    ("eight", '8');
    ("nine", '9');
  ]

let min_win = 1
let max_win = 5

let rec find_digits str pos win_size =
  let len = String.length str in
  if pos >= len then []
  else
    (* don't bother with bigger strings *)
    match pos + win_size > len || win_size > max_win with
    | true -> find_digits str (pos + 1) min_win (* next pos and restart window *)
    | false -> (
        let c = str.[pos] in
        if Char.is_digit c then c :: find_digits str (pos + 1) win_size
        else
          let n =
            List.find_map numbers ~f:(fun (name, number) ->
                let sub = String.sub str ~pos ~len:win_size in
                if String.compare sub name = 0 then Some number else None)
          in
          match n with
          | Some n -> n :: find_digits str (pos + 1) win_size
          | None -> find_digits str pos (win_size + 1))

let part_2 =
  let lines = AOC.Files.read_lines "input/d01.in" in
  List.fold lines ~init:0 ~f:(fun acc line ->
      let digits = find_digits line 0 min_win in
      let h = List.hd_exn digits in
      let l = List.last_exn digits in
      Int.of_string (String.of_char_list [ h; l ]) + acc)
  |> Fmt.pr "Part 2: %d\n"

let () =
  part_1;
  part_2
