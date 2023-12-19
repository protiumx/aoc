open Core

let lines = AOC.read_lines "input/d10.in"
let rows = List.length lines
let cols = String.length (List.hd_exn lines)
let in_bounds = AOC.matrix_in_bounds rows cols

module Hashtbl = Stdlib.Hashtbl
module CSet = AOC.CharSet

(* load matrix and find position of S *)
let load_matrix =
  let matrix = Array.make_matrix ~dimx:rows ~dimy:cols Char.min_value in
  let pos =
    List.foldi lines ~init:(-1, -1) ~f:(fun i pos line ->
        let col =
          String.foldi line ~init:(-1) ~f:(fun j y' ch ->
              matrix.(i).(j) <- ch;
              if Char.(ch = 'S') then j else y')
        in
        if col <> -1 then
          (i, col)
        else
          pos)
  in
  (matrix, pos)

let pipe_directions = function
  | '-' -> [ (0, 1); (0, -1) ] (* left, right *)
  | '|' -> [ (1, 0); (-1, 0) ] (* up, down *)
  | 'F' -> [ (1, 0); (0, 1) ] (* down, right *)
  | '7' -> [ (1, 0); (0, -1) ] (* down, left *)
  | 'L' -> [ (-1, 0); (0, 1) ] (* up, right *)
  | 'J' -> [ (-1, 0); (0, -1) ] (* up, left *)
  | _ -> assert false

let determine_s matrix (sx, sy) =
  let options = CSet.of_list [ '|'; 'L'; 'J'; 'F'; '7'; '-' ] in
  let up = CSet.of_list [ '|'; 'F'; '7' ] in
  let down = CSet.of_list [ '|'; 'L'; 'J' ] in
  let left = CSet.of_list [ '-'; 'L'; 'F' ] in
  let right = CSet.of_list [ '-'; 'J'; '7' ] in

  let options =
    List.fold AOC.directions_4 ~init:options ~f:(fun acc (i, j) ->
        let x, y = (sx + i, sy + j) in
        match (i, j) with
        | -1, 0 when in_bounds x y && Set.mem up matrix.(x).(y) -> Set.inter acc down
        | 1, 0 when in_bounds x y && Set.mem down matrix.(x).(y) -> Set.inter acc up
        | 0, -1 when in_bounds x y && Set.mem left matrix.(x).(y) -> Set.inter acc right
        | 0, 1 when in_bounds x y && Set.mem right matrix.(x).(y) -> Set.inter acc left
        | _ -> acc)
  in

  assert (Set.length options = 1);
  Set.nth options 0 |> Option.value_exn

let rec trace_loop matrix seen pos dist =
  match Hashtbl.mem seen pos with
  | true -> dist
  | false ->
      Hashtbl.add seen pos true;
      let x, y = pos in
      let dir =
        List.find
          (pipe_directions matrix.(x).(y))
          ~f:(fun (i, j) -> not (Hashtbl.mem seen (x + i, y + j)))
      in
      let i, j =
        match dir with
        | Some (i, j) -> (i, j)
        | None -> (0, 0)
      in
      trace_loop matrix seen (x + i, y + j) (dist + 1)

let part_1 =
  let matrix, (sx, sy) = load_matrix in
  matrix.(sx).(sy) <- determine_s matrix (sx, sy);

  let h = Hashtbl.create rows in
  let l = trace_loop matrix h (sx, sy) 0 in
  Fmt.pr "@.Part 1: %d@." (l / 2)

let part_2 =
  let matrix, (sx, sy) = load_matrix in
  matrix.(sx).(sy) <- determine_s matrix (sx, sy);

  let dist = Hashtbl.create rows in
  let _ = trace_loop matrix dist (sx, sy) 0 in

  let increase_parity = CSet.of_list [ '|'; 'L'; 'J' ] in

  let rec solve (x, y) tiles parity =
    match (x, y) with
    | x, _ when x >= rows -> tiles
    | _, y when y >= cols -> solve (x + 1, 0) tiles 0
    | x, y when (not (Hashtbl.mem dist (x, y))) && parity % 2 = 1 ->
        solve (x, y + 1) (tiles + 1) parity
    | x, y when Hashtbl.mem dist (x, y) && Set.mem increase_parity matrix.(x).(y) ->
        solve (x, y + 1) tiles (parity + 1)
    | x, y -> solve (x, y + 1) tiles parity
  in

  solve (0, 0) 0 0 |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
