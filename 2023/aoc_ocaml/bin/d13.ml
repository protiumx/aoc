open Core

let lines = AOC.read_lines "input/d13.in"

let rec collect_patterns lines acc current =
  match lines with
  | [] -> List.rev current :: acc |> List.rev
  | hd :: tl when String.is_empty hd -> collect_patterns tl (List.rev current :: acc) []
  | hd :: tl -> collect_patterns tl acc (hd :: current)

let horizontal_mirror (pattern : string list) max_diff =
  let size = List.length pattern in
  let rec aux pos =
    if pos >= size then
      None
    else
      let above, below = List.split_n pattern pos in
      let above = List.rev above in
      let z = List.zip_with_remainder above below |> fst in
      let diff =
        List.fold z ~init:0 ~f:(fun acc (a, b) ->
            let z = String.foldi a ~init:[] ~f:(fun idx acc ch -> (ch, b.[idx]) :: acc) in
            List.fold z ~init:acc ~f:(fun acc' (a', b') ->
                if Char.equal a' b' then
                  acc'
                else
                  acc' + 1))
      in
      if diff = max_diff then
        Some pos
      else
        aux (pos + 1)
  in
  aux 1

(* flip grid diagonally *)
let flip pattern =
  let size = String.length (List.hd_exn pattern) in
  let rec aux pos =
    if pos >= size then
      []
    else
      let f =
        List.fold pattern ~init:[] ~f:(fun acc block -> block.[pos] :: acc)
        |> List.rev
        |> String.of_list
      in
      f :: aux (pos + 1)
  in
  aux 0

let patterns = collect_patterns lines [] []

let solve max_diff =
  List.fold patterns ~init:0 ~f:(fun acc p ->
      let acc =
        acc
        +
        match horizontal_mirror p max_diff with
        | Some i -> i * 100
        | None -> 0
      in

      let acc =
        acc
        +
        match horizontal_mirror (flip p) max_diff with
        | Some i -> i
        | None -> 0
      in

      acc)

let part_1 = solve 0 |> Fmt.pr "@.Part 1: %d@."
let part_2 = solve 1 |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
