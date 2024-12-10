open Core
module Hashtbl = Stdlib.Hashtbl
module Set = Stdlib.Set

let lines = String.split_lines (AOC.get_input 6)
let rows = List.length lines
let cols = String.length (List.nth_exn lines 0)

module GuardState = struct
  type t = { pos : int * int; dir : int * int }

  let compare t1 t2 = Stdlib.compare (t1.pos, t1.dir) (t2.pos, t2.dir)
end

module Coords = struct
  type t = int * int

  let compare = Stdlib.compare
end

module GuardStatesSet = Set.Make (GuardState)
module CoordsSet = Set.Make (Coords)

type result = Outside of GuardStatesSet.t | Loop of Coords.t

let parse =
  let graph = Hashtbl.create (rows * cols) in
  let start =
    lines
    |> List.foldi ~init:(0, 0) ~f:(fun r acc line ->
           line
           |> String.to_list
           |> List.foldi ~init:acc ~f:(fun c acc ch ->
                  Hashtbl.add graph (r, c) ch;
                  if Char.equal ch '^' then (r, c) else acc))
  in
  (graph, start)

(* rotate dir by 90° *)
let rotate = function
  | -1, 0 -> (0, 1)
  | 0, 1 -> (1, 0)
  | 1, 0 -> (0, -1)
  | 0, -1 -> (-1, 0)
  | _ -> assert false

let next_step (r, c) (i, j) = (r + i, c + j)

let rec simulate state graph (guard : GuardState.t) =
  if GuardStatesSet.mem guard state then
    Loop guard.pos
  else
    let next = next_step guard.pos guard.dir in
    let state = state |> GuardStatesSet.add guard in
    match Hashtbl.find_opt graph next with
    | Some ch -> (
        match ch with
        (* do not advance, next could also be blocked *)
        | '#' -> simulate state graph { guard with dir = rotate guard.dir }
        | _ -> simulate state graph { guard with pos = next })
    | None -> Outside state

let part_1 =
  let graph, start = parse in
  match simulate GuardStatesSet.empty graph { pos = start; dir = (-1, 0) } with
  | Outside state ->
      state
      |> GuardStatesSet.elements
      |> List.map ~f:(fun (c : GuardState.t) -> c.pos)
      |> CoordsSet.of_list
      |> CoordsSet.cardinal
      |> Fmt.pr "Part 1: %d@."
  | Loop _ -> failwith "part 1 should not loop"

let add_block (r, c) graph =
  let graph = Hashtbl.copy graph in
  Hashtbl.replace graph (r, c) '#';
  graph

module T = Domainslib.Task

let part_2 =
  let pool = T.setup_pool ~num_domains:4 () in
  let graph, start = parse in
  let (guard : GuardState.t) = { pos = start; dir = (-1, 0) } in
  let ret =
    match simulate GuardStatesSet.empty graph guard with
    | Outside s -> s
    | _ -> failwith "wrong initial pass"
  in

  T.run pool (fun _ ->
      ret
      |> GuardStatesSet.elements
      |> List.map ~f:(fun (guard : GuardState.t) -> guard.pos)
      |> CoordsSet.of_list
      |> CoordsSet.remove (guard.pos) (* should not place a block on the guard's starting point *)
      |> (fun set ->
           CoordsSet.fold
             (fun pos acc ->
               let graph = add_block pos graph in
               T.async pool (fun _ -> simulate GuardStatesSet.empty graph guard) :: acc)
             set [])
      |> List.map ~f:(fun p -> T.await pool p)
      |> List.count ~f:(fun result ->
             match result with
             | Loop _ -> true
             | _ -> false))
  |> Fmt.pr "Part 2: %d@.";
  T.teardown_pool pool

let () =
  part_1;
  part_2
