open Core

let tests = String.split_lines (AOC.get_input 7) |> List.map ~f:AOC.numbers_from_string

let concat_op a b =
  let e =
    if b <> 0 then
      Float.log10 (float_of_int b) |> Float.round_down
    else
      -1.0
  in
  Float.(((of_int a) * (10.0 ** (e + 1.0))) + (of_int b)) |> int_of_float


let is_valid test concat = 
  let target = List.hd_exn test in
  let rec inner rem acc = 
    match rem with
    | [] -> acc = target
    | x::xs -> inner xs (acc * x) || inner xs (acc + x) || (concat && inner xs (concat_op acc x))
  in
  inner (List.tl_exn test) 0

let part_1 = 
  tests
  |> List.filter ~f:(fun t -> is_valid t false)
  |> List.fold ~init:0 ~f:(fun acc values -> acc + List.hd_exn values)
  |> Fmt.pr "Part 1: %d@."

let part_2 = 
  tests
  |> List.filter ~f:(fun t -> is_valid t true)
  |> List.fold ~init:0 ~f:(fun acc values -> acc + List.hd_exn values)
  |> Fmt.pr "Part 2: %d@."


let () = part_1; part_2
