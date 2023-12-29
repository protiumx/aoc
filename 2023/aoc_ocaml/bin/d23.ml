open Core

let lines = AOC.read_lines "input/d23.in"
let grid = Array.of_list lines
let rows = Array.length grid
let cols = String.length grid.(0)
let in_bounds = AOC.matrix_in_bounds rows cols
let start = (0, String.index grid.(0) '.' |> Option.value_exn)
let stop = (rows - 1, String.index grid.(rows - 1) '.' |> Option.value_exn)

(* path contraction: the input grid seems to not have more than 2 contiguous rows with forest points *)
(* search for all points where we can have 3+ different directions to choose *)
let decision_points =
  Array.foldi grid ~init:[ start; stop ] ~f:(fun r acc line ->
      String.foldi line ~init:acc ~f:(fun c acc' ch ->
          match ch with
          | '#' -> acc'
          | _ ->
              let neighbors =
                List.fold AOC.directions_4 ~init:0 ~f:(fun n (i, j) ->
                    if in_bounds (r + i) (c + j) && Char.(grid.(r + i).[c + j] <> '#') then
                      n + 1
                    else
                      n)
              in
              if neighbors >= 3 then
                (r, c) :: acc'
              else
                acc'))
  |> AOC.PointSet.of_list

let make_graph directions =
  (* create adjacency list (with distances) for directed graph *)
  let graph = AOC.PointHashtbl.create () in
  Hash_set.iter decision_points ~f:(fun point ->
      let node = Hashtbl.find_or_add graph point ~default:(fun () -> AOC.PointHashtbl.create ()) in

      let origin_x, origin_y = point in
      let stack = Stack.create () in
      (* 3rd is distance to point *)
      Stack.push stack (origin_x, origin_y, 0);
      let seen = AOC.PointSet.create () in
      Hash_set.add seen point;

      while not (Stack.is_empty stack) do
        let r, c, d = Stack.pop_exn stack in
        (* avoid self-reference by checking distance *)
        if d > 0 && Hash_set.mem decision_points (r, c) then
          Hashtbl.add_exn node ~key:(r, c) ~data:d
        else
          List.iter
            (directions grid.(r).[c])
            ~f:(fun (i, j) ->
              let r, c = (r + i, c + j) in
              if in_bounds r c && (not (Hash_set.mem seen (r, c))) && Char.(grid.(r).[c] <> '#')
              then (
                Hash_set.add seen (r, c);
                Stack.push stack (r, c, d + 1)))
      done);
  graph

let part_1 =
  (* directed acyclic graph (DAG) ? *)
  let directions = function
    | '^' -> [ (-1, 0) ]
    | 'v' -> [ (1, 0) ]
    | '>' -> [ (0, 1) ]
    | '<' -> [ (0, -1) ]
    | '.' -> AOC.directions_4
    | _ -> assert false
  in

  let graph = make_graph directions in

  let seen = AOC.PointSet.create () in
  let ordening = Stack.create () in

  let rec toposort point =
    Hash_set.add seen point;
    let edges = Hashtbl.find_exn graph point in
    Hashtbl.iteri edges ~f:(fun ~key ~data:_ ->
        if not (Hash_set.mem seen key) then
          toposort key);
    Stack.push ordening point
  in

  toposort start;

  let distances = AOC.PointHashtbl.create () in
  Hashtbl.iteri graph ~f:(fun ~key:p ~data:_ -> Hashtbl.set distances ~key:p ~data:(-1));
  Hashtbl.set distances ~key:start ~data:0;

  while not (Stack.is_empty ordening) do
    let p = Stack.pop_exn ordening in
    let node_distance = Hashtbl.find_exn distances p in
    if node_distance <> -1 then
      let node = Hashtbl.find_exn graph p in
      Hashtbl.iteri node ~f:(fun ~key ~data ->
          if Hashtbl.find_exn distances key < node_distance + data then
            Hashtbl.set distances ~key ~data:(node_distance + data))
  done;

  Hashtbl.find_exn distances stop |> Fmt.pr "@.Part 1: %d"

let part_2 =
  let directions _ = AOC.directions_4 in
  let graph = make_graph directions in

  (* brute force DFS *)
  let seen = AOC.PointSet.create () in
  let end_x, end_y = stop in
  let rec dfs point =
    match point with
    | r, c when r = end_x && c = end_y -> 0
    | _ ->
        Hash_set.add seen point;
        let node = Hashtbl.find_exn graph point in
        let max_distance =
          Hashtbl.fold node ~init:Int.min_value ~f:(fun ~key:next ~data:distance acc ->
              if not (Hash_set.mem seen next) then
                max acc (dfs next + distance)
              else
                acc)
        in
        Hash_set.remove seen point;
        max_distance
  in

  dfs start |> Fmt.pr "@.Part 2: %d"

let () =
  part_1;
  part_2
