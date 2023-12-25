open Core

let lines = AOC.read_lines "input/d18.in"

(* Shoelace theorem *)
let calc_area points =
  AOC.range_foldi
    (0, Array.length points)
    ~init:0
    ~f:(fun i acc ->
      let x, _ = points.(i) in
      let _, yi = if i - 1 < 0 then Array.last points else points.(i - 1) in
      let _, yj = points.((i + 1) % Array.length points) in
      acc + (x * (yi - yj)))
  |> abs

let points_with_boundaries lines parser =
  List.fold lines
    ~init:([ (0, 0) ], 0)
    ~f:(fun (acc, points) line ->
      let (i, j), count = parser line in
      let r, c = List.hd_exn acc in
      ((r + (i * count), c + (j * count)) :: acc, count + points))

let part_1 =
  let parse_direction line =
    let[@ocaml.warning "-8"] [ dir; count; _ ] = String.split line ~on:' ' in
    let dir =
      match dir.[0] with
      | 'R' -> (0, 1)
      | 'D' -> (1, 0)
      | 'L' -> (0, -1)
      | 'U' -> (-1, 0)
      | _ -> assert false
    in
    (dir, Int.of_string count)
  in

  let points, boundary_points = points_with_boundaries lines parse_direction in
  let points = Array.of_list (List.rev points) in
  let area = calc_area points / 2 in
  (* Pick's theorem *)
  let inner_points = area - (boundary_points / 2) + 1 in
  Fmt.pr "@.Part 1: %d@." (inner_points + boundary_points)

let part_2 =
  let parse_direction line =
    let[@ocaml.warning "-8"] [ _; _; color ] = String.split line ~on:' ' in
    let hx = String.strip color ~drop:(fun ch -> Char.(ch = '(' || ch = ')' || ch = '#')) in
    let dir =
      match hx.[5] with
      | '0' -> (0, 1)
      | '1' -> (1, 0)
      | '2' -> (0, -1)
      | '3' -> (-1, 0)
      | _ -> assert false
    in
    (dir, int_of_string ("0x" ^ String.slice hx 0 5))
  in

  let points, boundary_points = points_with_boundaries lines parse_direction in
  let points = Array.of_list (List.rev points) in
  let area = calc_area points / 2 in
  let inner_points = area - (boundary_points / 2) + 1 in
  Fmt.pr "@.Part 2: %d@." (inner_points + boundary_points)

let () =
  part_1;
  part_2
