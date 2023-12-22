open Core

let lines = AOC.read_lines "input/d15.in"

type action = Remove | Add

module Hashtbl = Stdlib.Hashtbl

module Instruction = struct
  type t = { action : action; label : string; focal_length : int; box : int }

  let hash = String.fold ~init:0 ~f:(fun acc ch -> (acc + int_of_char ch) * 17 % 256)

  let make s =
    let parts = String.split_on_chars s ~on:[ '='; '-' ] in
    let label = List.hd_exn parts in
    let box = hash label in
    if String.is_empty (List.last_exn parts) then
      { action = Remove; label; focal_length = 0; box }
    else
      { action = Add; label; focal_length = Int.of_string (List.nth_exn parts 1); box }
end

let part_1 =
  List.hd_exn lines
  |> String.split ~on:','
  |> List.fold ~init:0 ~f:(fun acc seq -> acc + Instruction.hash seq)
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let instructions = List.hd_exn lines |> String.split ~on:',' |> List.map ~f:Instruction.make in
  let boxes = Array.create ~len:256 [] in
  let focal_lengths = Hashtbl.create 256 in
  List.iter instructions ~f:(fun instruction ->
      let box = boxes.(instruction.box) in
      match instruction.action with
      | Remove ->
          let box = List.filter box ~f:(String.( <> ) instruction.label) in
          boxes.(instruction.box) <- box
      | Add ->
          if List.find box ~f:(String.equal instruction.label) |> Option.is_none then
            boxes.(instruction.box) <- List.append box [ instruction.label ];

          Hashtbl.add focal_lengths instruction.label instruction.focal_length);

  Array.foldi boxes ~init:0 ~f:(fun boxid acc box ->
      acc
      + List.foldi box ~init:0 ~f:(fun labelid acc' label ->
            acc' + ((boxid + 1) * (labelid + 1) * Hashtbl.find focal_lengths label)))
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
