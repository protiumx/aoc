open Core
module Hashtbl = Stdlib.Hashtbl

let lines = String.split_lines (AOC.get_test_input 5)

let parse =
  let rules, updates = List.split_while lines ~f:(fun line -> not (String.is_empty line)) in
  let rules =
    rules
    |> List.map ~f:(fun line ->
           let a, b = AOC.split_once '|' line in
           (int_of_string a, int_of_string b))
    |> AOC.PointSet.of_list
  in
  let updates =
    List.drop updates 1
    |> List.map ~f:(fun update -> update |> String.split ~on:',' |> List.map ~f:int_of_string)
  in
  (rules, updates)

let valid_update rules update =
  AOC.window update 2
  (* Verify that there is a rule for each pair of pages *)
  |> List.exists ~f:(fun p ->
         Hash_set.mem rules (List.nth_exn p 0, List.nth_exn p 1) |> Stdlib.Bool.not)
  |> Stdlib.Bool.not

let middle update = List.nth_exn update (List.length update / 2)

let part_1 =
  let rules, updates = parse in
  updates
  |> List.filter ~f:(valid_update rules)
  |> List.map ~f:middle
  |> List.fold ~init:0 ~f:( + )
  |> Fmt.pr "Part 1: %d@."

let pair_up elem list =
  let rec inner rem acc =
    match rem with
    | x :: xs -> inner xs ((elem, x) :: acc)
    | [] -> acc
  in
  inner list []

let fix_update rules update =
  List.map update ~f:(fun page -> (page, List.count (pair_up page update) ~f:(Hash_set.mem rules)))
  (* Sort pages by the least number rules, pages to the right should have less rules *)
  |> List.sort ~compare:(fun (_, a) (_, b) -> compare b a)
  |> List.map ~f:fst

let part_2 =
  let rules, updates = parse in
  updates
  |> List.filter ~f:(fun update -> not (valid_update rules update))
  |> List.map ~f:(fix_update rules)
  |> List.map ~f:middle
  |> List.fold ~init:0 ~f:( + )
  |> Fmt.pr "Part 2: %d@."

let () =
  part_1;
  part_2
