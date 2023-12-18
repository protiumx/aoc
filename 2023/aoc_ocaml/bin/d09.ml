open Core

let lines = AOC.read_lines "input/d09.in"

let readings =
  List.map lines ~f:(fun line -> String.split line ~on:' ' |> List.map ~f:Int.of_string)

let deltas reading =
  List.zip_with_remainder reading (List.slice reading 1 (List.length reading))
  |> fst
  |> List.map ~f:(fun (a, b) -> b - a)

let part_1 =
  let rec extrapolate reading =
    match reading with
    | r when List.for_all r ~f:(fun x -> x = 0) -> 0
    | _ -> List.last_exn reading + extrapolate (deltas reading)
  in

  List.fold readings ~init:0 ~f:(fun acc reading ->
      let p = extrapolate reading in
      p + acc)
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let rec extrapolate reading =
    match reading with
    | r when List.for_all r ~f:(fun x -> x = 0) -> 0
    | _ -> List.hd_exn reading - extrapolate (deltas reading)
  in

  List.fold readings ~init:0 ~f:(fun acc reading ->
      let p = extrapolate reading in
      p + acc)
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
