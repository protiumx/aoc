open Core

let lines = AOC.read_lines "input/d11.in"
let rows = List.length lines
let cols = String.length (List.hd_exn lines)

module IntSet = Set.Make (Int)

let load_matrix =
  let matrix = Array.make_matrix ~dimx:rows ~dimy:cols Char.min_value in
  List.iteri lines ~f:(fun i line -> String.iteri line ~f:(fun j ch -> matrix.(i).(j) <- ch));
  matrix

let matrix = load_matrix

let empty_rows =
  Array.foldi matrix ~init:IntSet.empty ~f:(fun i acc row ->
      if Array.for_all row ~f:(fun ch -> Char.(ch = '.')) then
        Set.add acc i
      else
        acc)

let empty_cols =
  Array.foldi matrix.(0) ~init:IntSet.empty ~f:(fun i acc _ ->
      if Array.for_all matrix ~f:(fun row -> Char.(row.(i) = '.')) then
        Set.add acc i
      else
        acc)

let galaxies =
  Array.foldi matrix ~init:[] ~f:(fun i acc row ->
      let points =
        Array.foldi row ~init:[] ~f:(fun j acc' ch ->
            if Char.(ch = '#') then
              (i, j) :: acc'
            else
              acc')
      in
      List.append points acc)

let expand scale =
  List.foldi galaxies ~init:0 ~f:(fun i acc (r1, c1) ->
      List.fold (List.sub galaxies ~pos:0 ~len:i) ~init:acc ~f:(fun acc' (r2, c2) ->
          let acc =
            AOC.range_fold
              (min r1 r2, max r1 r2)
              ~init:acc'
              ~f:(fun r acc -> acc + if Set.mem empty_rows r then scale else 1)
          in
          AOC.range_fold
            (min c1 c2, max c1 c2)
            ~init:acc
            ~f:(fun c acc -> acc + if Set.mem empty_cols c then scale else 1)))

let part_1 = expand 2 |> Fmt.pr "@.Part 1: %d@."
let part_2 = expand 1000000 |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
