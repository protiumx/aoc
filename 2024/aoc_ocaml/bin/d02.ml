open Core

let input = String.split_lines (AOC.get_input 2)

let count_safe_levels tolerance =
  let rec is_safe levels prev dir =
    match levels with
    | [] -> true
    | x :: _ when not (AOC.range_contains (1, 3) ((x - prev) * dir)) -> false
    | x :: xs -> is_safe xs x dir
  in

  let report_direction l =
    match List.nth_exn l 1 - List.nth_exn l 0 with
    | d when d >= 0 -> 1
    | _ -> -1
  in

  List.fold input ~init:0 ~f:(fun acc line ->
      let levels = AOC.numbers_from_string line in
      (* count safe combinations *)
      let count =
        AOC.range_fold_until
          (* use -1 so first iteration uses all reports *)
          (-1, List.length levels)
          ~init:0
          ~f:(fun count i ->
            let levels = List.filteri levels ~f:(fun fi _ -> fi <> i) in
            let dir = report_direction levels in
            let safe = is_safe (List.tl_exn levels) (List.hd_exn levels) dir in
            let count = count + if safe then 1 else 0 in
            if tolerance = 0 then
              Stop count
            else
              Continue count)
      in

      acc + if count > 0 then 1 else 0)

let part_1 = count_safe_levels 0 |> Fmt.pr "Part 1: %d@."
let part_2 = count_safe_levels 1 |> Fmt.pr "Part 2: %d@."

let () =
  part_1;
  part_2
