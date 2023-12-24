open Core

let lines = AOC.read_lines "input/d17.in"

let grid =
  List.map lines ~f:(fun line ->
      String.to_array line |> Array.map ~f:(fun ch -> int_of_char ch - int_of_char '0'))
  |> Array.of_list

let rows = Array.length grid
let cols = Array.length grid.(0)
let in_bounds = AOC.matrix_in_bounds rows cols

module Hashtbl = Stdlib.Hashtbl

let part_1 =
  let pq =
    Pairing_heap.create ~cmp:(fun (_, _, a, _, _, _) (_, _, b, _, _, _) -> Int.compare a b) ()
  in
  (* y x loss, dy, dx, n of steps *)
  Pairing_heap.add pq (0, 1, grid.(0).(1), 0, 1, 1);
  Pairing_heap.add pq (1, 0, grid.(1).(0), 1, 0, 1);
  let seen = Hashtbl.create (rows * cols) in
  let rec solve () =
    if Pairing_heap.is_empty pq then
      0
    else
      let r, c, loss, dr, dc, steps = Pairing_heap.pop_exn pq in
      if r = rows - 1 && c = cols - 1 then
        loss
      else if Hashtbl.mem seen (r, c, dr, dc, steps) then
        solve ()
      else (
        Hashtbl.add seen (r, c, dr, dc, steps) true;
        let candidates =
          (* can continue in the same direction *)
          if steps < 3 then
            [ (r + dr, c + dc, loss, dr, dc, steps + 1) ]
          else
            []
        in

        let candidates =
          List.filter AOC.directions_4 ~f:(fun (i, j) ->
              (* cannot go in the same directions *)
              (i <> dr || j <> dc) && (i <> -dr || j <> -dc))
          |> List.fold ~init:candidates ~f:(fun acc (i, j) -> (r + i, c + j, loss, i, j, 1) :: acc)
        in

        List.iter candidates ~f:(fun (r, c, loss, dr, dc, steps) ->
            if in_bounds r c then
              Pairing_heap.add pq (r, c, loss + grid.(r).(c), dr, dc, steps));

        solve ())
  in
  solve () |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let pq =
    Pairing_heap.create ~cmp:(fun (_, _, a, _, _, _) (_, _, b, _, _, _) -> Int.compare a b) ()
  in
  Pairing_heap.add pq (0, 1, grid.(0).(1), 0, 1, 1);
  Pairing_heap.add pq (1, 0, grid.(1).(0), 1, 0, 1);

  let seen = Hashtbl.create (rows * cols) in

  let rec solve () =
    if Pairing_heap.is_empty pq then
      0
    else
      let r, c, loss, dr, dc, steps = Pairing_heap.pop_exn pq in
      if r = rows - 1 && c = cols - 1 && steps >= 4 then
        loss
      else if Hashtbl.mem seen (r, c, dr, dc, steps) then
        solve ()
      else (
        Hashtbl.add seen (r, c, dr, dc, steps) true;
        let candidates =
          if steps < 10 then
            [ (r + dr, c + dc, loss, dr, dc, steps + 1) ]
          else
            []
        in

        let candidates =
          if steps >= 4 then
            List.filter AOC.directions_4 ~f:(fun (i, j) ->
                (i <> dr || j <> dc) && (i <> -dr || j <> -dc))
            |> List.fold ~init:candidates ~f:(fun acc (i, j) ->
                   (r + i, c + j, loss, i, j, 1) :: acc)
          else
            candidates
        in

        List.iter candidates ~f:(fun (r, c, loss, dr, dc, steps) ->
            if in_bounds r c then
              Pairing_heap.add pq (r, c, loss + grid.(r).(c), dr, dc, steps));

        solve ())
  in
  solve () |> Fmt.pr "@.Part 1: %d@."

let () =
  part_1;
  part_2
