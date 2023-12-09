open Core
module StringSet = Stdlib.Set.Make (String)

let lines = AOC.read_lines "input/d04.in"

let part_1 =
  List.fold lines ~init:0 ~f:(fun acc line ->
      let card = String.slice line (String.index_exn line ':' + 1) (String.length line) in
      let numbers = String.split card ~on:'|' in
      let winning_numbers =
        List.filter
          (String.split (List.hd_exn numbers) ~on:' ')
          ~f:(fun s -> not (String.is_empty s))
      in
      let winning_set = StringSet.of_list winning_numbers in
      acc
      + List.fold
          (String.split (List.last_exn numbers) ~on:' ')
          ~init:0
          ~f:(fun acc' n ->
            if StringSet.mem n winning_set then if acc' = 0 then 1 else acc' * 2 else acc'))
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let scores =
    List.fold lines ~init:[] ~f:(fun acc line ->
        let card = String.slice line (String.index_exn line ':' + 1) (String.length line) in
        let numbers = String.split card ~on:'|' in
        let winning_numbers =
          List.filter
            (String.split (List.hd_exn numbers) ~on:' ')
            ~f:(fun s -> not (String.is_empty s))
        in
        let set = StringSet.of_list winning_numbers in
        let score =
          List.fold
            (String.split (List.last_exn numbers) ~on:' ')
            ~init:0
            ~f:(fun acc' n -> acc' + if StringSet.mem n set then 1 else 0)
        in

        score :: acc)
    |> List.rev
  in
  let copies = Array.create ~len:(List.length lines) 1 in
  List.iteri scores ~f:(fun idx score ->
      AOC.range_iter 1 (score + 1) (fun offset ->
          let card = offset + idx in
          copies.(card) <- copies.(card) + copies.(idx)));
  Fmt.pr "@.Part 2: %d@." (Array.reduce_exn copies ~f:( + ))

let () =
  part_1;
  part_2
