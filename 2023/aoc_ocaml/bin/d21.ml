[@@@warning "-32"]

open Core

let lines = AOC.read_lines "input/d21.in"
let steps = 64
let matrix = List.map lines ~f:String.to_array |> Array.of_list
let rows = Array.length matrix
let cols = Array.length matrix.(0)
let in_bounds = AOC.matrix_in_bounds rows cols

module IntPair = struct
  module T = struct
    type t = int * int

    let compare x y = Tuple2.compare ~cmp1:Int.compare ~cmp2:Int.compare x y
    let sexp_of_t = Tuple2.sexp_of_t Int.sexp_of_t Int.sexp_of_t
    let t_of_sexp = Tuple2.t_of_sexp Int.t_of_sexp Int.t_of_sexp
    let hash = Hashtbl.hash
  end

  include T
  include Comparable.Make (T)
end

module PointSet = Hash_set.Make (IntPair)

let walk_gardens steps (sx, sy) =
  let q = Queue.of_list [ (sx, sy, steps) ] in
  let seen = PointSet.create () in
  let points = PointSet.create () in
  Hash_set.add seen (sx, sy);

  let rec aux () =
    if Queue.is_empty q then
      ()
    else
      let i, j, steps = Queue.dequeue_exn q in
      if steps % 2 = 0 then
        Hash_set.add points (i, j);
      if steps = 0 then
        ()
      else
        List.iter AOC.directions_4 ~f:(fun (r, c) ->
            let r, c = (i + r, c + j) in
            if in_bounds r c && (not (Hash_set.mem seen (r, c))) && Char.(matrix.(r).(c) <> '#')
            then (
              Hash_set.add seen (r, c);
              Queue.enqueue q (r, c, steps - 1)));

      aux ()
  in

  aux ();
  Hash_set.length points

let sx, sy =
  List.foldi lines ~init:(-1, -1) ~f:(fun i acc line ->
      match String.index line 'S' with
      | Some j -> (i, j)
      | None -> acc)

let part_1 =
  assert (sx >= 0);
  assert (sy >= 0);
  walk_gardens 64 (sx, sy) |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  (* assumptions: *)
  (* - the grid is square *)
  (* - size of grid is an odd number *)
  (* - we start at the middle of the grid *)
  (* - the number of steps is enough to get to the last edge of the grid *)
  (* - row and col containing S are empty. this means the solution of repeated grids has a diamond shape *)
  let size = rows in
  assert (size = cols);
  assert (size / 2 = sx);

  let steps = 26501365 in
  assert (steps % size = size / 2);

  let grid_width = (steps / size) - 1 in
  let odd_grids = Int.pow (1 + (grid_width / 2 * 2)) 2 in
  let even_grids = Int.pow ((grid_width + 1) / 2 * 2) 2 in

  (* walk the grid by parts: calculate inner part (+), corners and remaining sections *)
  (*   # *)
  (*  ###  *)
  (* ##### *)
  (*  ### *)
  (*   # *)

  (* walk the gardens enough to find odd and event points within the grid *)
  let odd_points = walk_gardens ((size * 2) + 1) (sx, sy) in
  let even_points = walk_gardens (size * 2) (sx, sy) in

  (* handle points in corners ^v <> *)
  let corners_poinnts =
    [ (size - 1, sy); (0, sy); (sx, 0); (sx, size - 1) ]
    |> List.fold ~init:0 ~f:(fun acc point -> acc + walk_gardens (size - 1) point)
  in

  (* handle extra parts between corners *)
  let extra_corner_points =
    [ (size - 1, 0); (0, 0); (size - 1, size - 1); (0, size - 1) ]
    |> List.fold ~init:0 ~f:(fun acc point -> acc + walk_gardens ((size / 2) - 1) point)
  in

  let extra_points = (grid_width + 1) * extra_corner_points in

  let remaining_points =
    [ (size - 1, 0); (0, 0); (size - 1, size - 1); (0, size - 1) ]
    |> List.fold ~init:0 ~f:(fun acc point -> acc + walk_gardens ((3 * size / 2) - 1) point)
  in
  let remaining_points = remaining_points * grid_width in
  let ans =
    (odd_grids * odd_points)
    + (even_grids * even_points)
    + corners_poinnts
    + extra_points
    + remaining_points
  in
  Fmt.pr "@.Part 2: %d" ans

let () =
  part_1;
  part_2
