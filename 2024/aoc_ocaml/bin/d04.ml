open Core
module Hashtbl = Stdlib.Hashtbl

let lines = String.split_lines (AOC.get_input 4)
let matrix, rows, cols = AOC.load_matrix_from_lines lines
let in_bounds = AOC.matrix_in_bounds rows cols
let xmas = [ 'X'; 'M'; 'A'; 'S' ]
let xmax_directions = [ (-1, -1); (-1, 1); (1, 1); (1, -1) ]

(* collect starting points *)
let search_points ch =
  Array.foldi matrix ~init:[] ~f:(fun r acc row ->
      Array.foldi row ~init:acc ~f:(fun c acc' col ->
          if Char.equal col ch then (r, c) :: acc' else acc'))

let matches word centered (r, c) (i, j) =
  (* if (r, c) is the center we move the coordinate in the opposite direction to match from the start *)
  let r, c = if centered then (r + (i * -1), c + (j * -1)) else (r, c) in
  word
  |> List.for_alli ~f:(fun offset letter ->
         let r, c = (r + (offset * i), c + (offset * j)) in
         in_bounds r c && Char.equal matrix.(r).(c) letter)

let find_matches word dirs centered (r, c) =
  dirs |> List.map ~f:(matches word centered (r, c)) |> List.count ~f:(fun m -> m)

let part_1 =
  search_points 'X'
  |> List.map ~f:(find_matches xmas AOC.directions false)
  |> List.fold ~init:0 ~f:( + )
  |> Fmt.pr "Part 1: %d@."

let part_2 =
  search_points 'A'
  |> List.map ~f:(find_matches (List.tl_exn xmas) xmax_directions true)
  |> List.fold ~init:0 ~f:(fun acc c -> if c = 2 then 1 + acc else acc)
  |> Fmt.pr "Part 2: %d@."

let () =
  part_1;
  part_2
