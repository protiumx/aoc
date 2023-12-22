open Core

let lines = AOC.read_lines "input/d14.in"

module Hashtbl = Stdlib.Hashtbl

let flip pattern =
  let size = String.length (List.hd_exn pattern) in
  let rec aux pos =
    if pos >= size then
      []
    else
      let f =
        List.fold pattern ~init:[] ~f:(fun acc block -> block.[pos] :: acc)
        |> List.rev
        |> String.of_list
      in
      f :: aux (pos + 1)
  in
  aux 0

let part_1 =
  let size = List.length lines in
  flip lines
  |> List.map ~f:(fun line ->
         String.split line ~on:'#'
         |> List.map ~f:(fun s ->
                String.to_list s
                |> List.sort ~compare:(fun a b -> if Char.(a >= b) then -1 else 1)
                |> String.of_list)
         |> String.concat ~sep:"#")
  |> flip (* flip back *)
  |> List.foldi ~init:0 ~f:(fun idx acc line ->
         acc + (String.count line ~f:(Char.equal 'O') * (size - idx)))
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let rotate grid =
    flip grid
    |> List.map ~f:(fun line ->
           String.split line ~on:'#'
           |> List.map ~f:(fun s ->
                  String.to_list s
                  |> List.sort ~compare:(fun a b -> if Char.(a >= b) then -1 else 1)
                  |> String.of_list)
           |> String.concat ~sep:"#")
    |> List.map ~f:String.rev
  in

  let cycle grid = AOC.range_fold (0, 4) ~init:grid ~f:rotate in

  let seen = Hashtbl.create 1000 in
  Hashtbl.add seen lines true;

  let rec solve grid iterations grids =
    let grid = cycle grid in
    let iterations = iterations + 1 in
    if Hashtbl.mem seen grid then
      (iterations, grid, List.rev grids)
    else (
      Hashtbl.add seen grid true;
      solve grid iterations (grid :: grids))
  in

  let iterations, grid, grids = solve lines 0 [ lines ] in
  let i, _ = List.findi_exn grids ~f:(fun _ g -> List.equal String.equal g grid) in
  Fmt.pr "@.cycle found at iteration %d at index %d" iterations i;
  let grid = List.nth_exn grids (((1000000000 - i) % (iterations - i)) + i) in

  let size = List.length grid in
  List.foldi grid ~init:0 ~f:(fun idx acc line ->
      acc + (String.count line ~f:(Char.equal 'O') * (size - idx)))
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
