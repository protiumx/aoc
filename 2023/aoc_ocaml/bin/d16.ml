open Core

let lines = AOC.read_lines "input/d16.in"
let grid = List.map lines ~f:String.to_array |> Array.of_list
let rows = Array.length grid
let cols = Array.length grid.(0)
let in_bounds = AOC.matrix_in_bounds rows cols

module Hashtbl = Stdlib.Hashtbl

let simulate_beams (y, x) (dy, dx) =
  let q : (int * int * int * int) Queue.t = Queue.create () in
  let seen = Hashtbl.create (rows * cols) in
  Queue.enqueue q (y, x, dy, dx);

  let rec aux () =
    if Queue.is_empty q then
      ()
    else
      let y, x, dy, dx = Queue.dequeue_exn q in
      let y, x = (y + dy, x + dx) in
      if not (in_bounds y x) then
        aux ()
      else
        let candidates =
          match grid.(y).(x) with
          | ch when Char.(ch = '.') || (Char.(ch = '-') && dx <> 0) || (Char.(ch = '|') && dy <> 0)
            ->
              [ (y, x, dy, dx) ]
          | ch when Char.(ch = '/') -> [ (y, x, -dx, -dy) ]
          | ch when Char.(ch = '\\') -> [ (y, x, dx, dy) ]
          | ch ->
              let dirs = if Char.(ch = '|') then [ (1, 0); (-1, 0) ] else [ (0, 1); (0, -1) ] in
              List.fold dirs ~init:[] ~f:(fun acc (i, j) -> (y, x, i, j) :: acc)
        in

        List.iter candidates ~f:(fun c ->
            if not (Hashtbl.mem seen c) then (
              Queue.enqueue q c;
              Hashtbl.replace seen c true));
        aux ()
  in
  aux ();
  let dedup = Hashtbl.create (Hashtbl.length seen) in
  Hashtbl.iter (fun (y, x, _, _) v -> Hashtbl.replace dedup (y, x) v) seen;
  Hashtbl.length dedup

let part_1 = simulate_beams (0, -1) (0, 1) |> Fmt.pr "@.Part 1: %d@."
(* Array.iter grid ~f:(fun row -> Fmt.pr "@.%s" (String.of_array row)) *)

let part_2 =
  let max_rows =
    AOC.range_foldi (0, rows) ~init:0 ~f:(fun i acc ->
        let max_left = max acc (simulate_beams (i, -1) (0, 1)) in
        let max_right = max acc (simulate_beams (i, cols) (0, -1)) in
        max max_left max_right)
  in

  let max_cols =
    AOC.range_foldi (0, cols) ~init:0 ~f:(fun i acc ->
        let max_top = max acc (simulate_beams (-1, i) (1, 0)) in
        let max_bottom = max acc (simulate_beams (rows, i) (-1, 0)) in
        max max_top max_bottom)
  in

  max max_cols max_rows |> Fmt.pr "@.Part 2: %d"

let () =
  part_1;
  part_2
