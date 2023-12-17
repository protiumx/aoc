[@@@warning "-8"]

open Core
module Hashtbl = Stdlib.Hashtbl

let lines = AOC.read_lines "input/d08.in"

let make_step line =
  let id, directions = AOC.split_once '=' line in
  let left = String.slice directions 2 5 in
  let right = String.slice directions 7 10 in
  let id = String.slice id 0 3 in
  (id, left, right)

let make_sequence from =
  (* a simple array would be enough *)
  let arr = Array.of_list from in
  let len = Array.length arr in
  Seq.unfold (fun idx -> Some (arr.(idx mod len), idx + 1)) 0

let directions =
  List.hd_exn lines |> String.to_list |> List.map ~f:(fun c -> if Char.equal c 'L' then -1 else 1)

let nodes = List.slice lines 2 (List.length lines) |> List.map ~f:make_step

let part_1 =
  let nodes_map = Hashtbl.create (List.length nodes) in
  List.iter nodes ~f:(fun (id, l, r) -> Hashtbl.add nodes_map id (l, r));

  let start = "AAA" in
  let dest = "ZZZ" in

  let rec solve dirs_seq (left, right) count =
    let h, seq = Seq.uncons dirs_seq |> Option.value_exn in
    let current = if h = -1 then left else right in
    if String.compare current dest = 0 then count
    else
      let next = Hashtbl.find nodes_map current in
      solve seq next (count + 1)
  in

  let l, r = Hashtbl.find nodes_map start in
  solve (make_sequence directions) (l, r) 1 |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let nodes_map = Hashtbl.create (List.length nodes) in
  List.iter nodes ~f:(fun (id, l, r) -> Hashtbl.add nodes_map id (l, r));

  let start =
    List.filter nodes ~f:(fun (id, _, _) -> String.is_suffix id ~suffix:"A") |> List.map ~f:fst3
  in
  let dest_map = Hashtbl.create (List.length start) in

  (* requirement: next node after **Z should be its start node *)
  let rec solve dirs current count =
    let dir, seq = Seq.uncons dirs |> Option.value_exn in
    if Hashtbl.length dest_map = List.length current then
      AOC.llcm (Hashtbl.fold (fun _ v acc -> v :: acc) dest_map [])
    else
      let get = if dir = -1 then fst else snd in
      let current =
        List.mapi current ~f:(fun idx node ->
            let n = Hashtbl.find nodes_map node |> get in
            if String.is_suffix n ~suffix:"Z" then Hashtbl.add dest_map idx (count + 1);
            n)
      in

      solve seq current (count + 1)
  in

  solve (make_sequence directions) start 0 |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
