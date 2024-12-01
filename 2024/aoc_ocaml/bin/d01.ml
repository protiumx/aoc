open Core
module Hashtbl = Stdlib.Hashtbl

let lines = String.split_lines (AOC.get_input 1)

let part_1 =
  let left, right =
    List.fold lines ~init:([], []) ~f:(fun (left, right) line ->
        let[@warning "-partial-match"] [ l; r ] = AOC.numbers_from_string line in
        (l :: left, r :: right))
  in
  let left = List.sort ~compare:(fun a b -> if a >= b then 1 else -1) left in
  let right = List.sort ~compare:(fun a b -> if a >= b then 1 else -1) right in

  List.foldi left ~init:0 ~f:(fun i acc l -> acc + Int.abs (l - List.nth_exn right i))
  |> Fmt.pr "Part 1: %d@."

let part_2 =
  let hash = Hashtbl.create (List.length lines) in
  let left =
    List.fold lines ~init:[] ~f:(fun acc line ->
        let[@warning "-partial-match"] [ l; r ] = AOC.numbers_from_string line in
        (match Hashtbl.find_opt hash r with
        | Some count -> Hashtbl.replace hash r (count + 1)
        | None -> Hashtbl.add hash r 1);

        l :: acc)
  in
  List.fold left ~init:0 ~f:(fun acc l ->
      match Hashtbl.find_opt hash l with
      | Some count -> acc + (l * count)
      | None -> acc)
  |> Fmt.pr "Part 2: %d@."

let () =
  part_1;
  part_2
