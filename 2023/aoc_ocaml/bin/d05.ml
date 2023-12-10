[@@@warning "-8"] (* suppress non-exhaustive matching *)

open Core

let lines = AOC.read_lines "input/d05.in"
let (_ :: seeds_nums) = String.split (List.hd_exn lines) ~on:' '
let seeds = List.map seeds_nums ~f:Int.of_string

let rec collect_functions lines functions ranges =
  match lines with
  | [] -> List.rev ranges :: functions
  | h :: t when String.is_empty h ->
      collect_functions t (List.rev ranges :: functions) [] (* end of function *)
  | h :: t when not (Char.is_digit h.[0]) ->
      collect_functions t functions ranges (* discard names *)
  | h :: t ->
      let [ dest_start; source_start; size ] = List.map (String.split h ~on:' ') ~f:Int.of_string in
      collect_functions t functions ((dest_start, source_start, size) :: ranges)

let (_ :: _ :: lines) = lines (* discard seeds and empty line *)
let functions = collect_functions lines [] [] |> List.rev

let part_1 =
  let rec apply_function ranges point =
    match ranges with
    | [] -> point
    | (dest, source, size) :: t ->
        if source <= point && point < source + size then dest + point - source
        else apply_function t point
  in

  let rec apply_functions functions point =
    match functions with
    | [] -> point
    | ranges :: t -> apply_functions t (apply_function ranges point)
  in

  List.fold seeds ~init:Int.max_value ~f:(fun acc point ->
      min (apply_functions functions point) acc)
  |> Fmt.pr "@.Part 1: %d@."

type point_stack = (int * int) Stack.t

let part_2 =
  assert (List.length seeds mod 2 = 0);

  let rec seeds_ranges s =
    match s with
    | [] -> []
    | source :: len :: t -> (source, len) :: seeds_ranges t
  in

  let seeds = seeds_ranges seeds in

  let is_valid_range (a, b) = b > a in

  (* [p_start   [low,    high]       p_end) *)
  (* [before   ][inter       ][      after) *)
  let split_ranges (dest, source, size) (p_start, p_end) =
    let source_end = source + size in
    let before = (p_start, min source p_end) in
    let inter = (max p_start source, min source_end p_end) in
    let after = (max p_start source_end, p_end) in

    let before = if is_valid_range before then Some before else None in
    let after = if is_valid_range after then Some after else None in
    let inter =
      if is_valid_range inter then
        let s, e = inter in
        Some (dest + s - source, dest + e - source)
      else None
    in

    (before, inter, after)
  in

  let rec apply_function ranges (points : point_stack) (intersections : point_stack) =
    match ranges with
    | [] ->
        Stack.iter intersections ~f:(Stack.push points);
        points
    | range :: t ->
        let rest = Stack.create () in
        Stack.iter points ~f:(fun p ->
            let before, inter, after = split_ranges range p in

            if Option.is_some before then Stack.push rest (Option.value_exn before);
            if Option.is_some after then Stack.push rest (Option.value_exn after);

            match inter with
            | Some i -> Stack.push intersections i
            | None -> ());
        apply_function t rest intersections
  in

  let rec apply_functions fns (points : point_stack) =
    match fns with
    | [] -> points
    | ranges :: t ->
        let intersections = Stack.create () in
        let rest = apply_function ranges points intersections in
        apply_functions t rest
  in

  List.fold seeds ~init:Int.max_value ~f:(fun acc (source, size) ->
      let points = Stack.create () in
      Stack.push points (source, source + size);
      Stack.fold (apply_functions functions points) ~init:acc ~f:(fun acc' (s, _) -> min s acc'))
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
