open Core

let part_1 =
  let red_cubes = 12 in
  let green_cubes = 13 in
  let blue_cubes = 14 in

  let lines = AOC.Files.read_lines "input/d02.in" in

  let is_valid_color_count n c =
    match c with
    | "red" -> n <= red_cubes
    | "blue" -> n <= blue_cubes
    | "green" -> n <= green_cubes
    | _ -> assert false
  in

  let is_valid_color s =
    match String.split s ~on:' ' with
    | [ n; c ] | [ _; n; c ] -> is_valid_color_count (Int.of_string n) c
    | _ -> assert false
  in

  let is_valid_round s = List.for_all (String.split s ~on:',') ~f:is_valid_color in
  let is_valid_game s =
    let pos = String.index_exn s ':' in
    let len = String.length s - pos in
    List.for_all (String.split (String.sub s ~pos ~len) ~on:';') ~f:is_valid_round
  in

  List.foldi lines ~init:0 ~f:(fun i acc line -> acc + if is_valid_game line then i + 1 else 0)
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let lines = AOC.Files.read_lines "input/d02.in" in

  let color_count s =
    match String.split s ~on:' ' with
    | [ n; c ] | [ _; n; c ] -> (Int.of_string n, c)
    | _ -> assert false
  in

  let round_counts s =
    List.fold (String.split s ~on:',') ~init:(0, 0, 0) ~f:(fun (r, b, g) color ->
        match color_count color with
        | n, "red" -> (r + n, b, g)
        | n, "blue" -> (r, b + n, g)
        | n, "green" -> (r, b, g + n)
        | _ -> (r, b, g))
  in

  let game_max s =
    let pos = String.index_exn s ':' in
    let len = String.length s - pos in
    let counts = List.map (String.split (String.sub s ~pos ~len) ~on:';') ~f:round_counts in
    List.fold counts ~init:(1, 1, 1) ~f:(fun (r, b, g) (rr, rb, rg) ->
        let red = if r < rr then rr else r in
        let blue = if b < rb then rb else b in
        let green = if g < rg then rg else g in
        (red, blue, green))
  in

  List.fold lines ~init:0 ~f:(fun acc line ->
      let r, b, g = game_max line in
      acc + (r * b * g))
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
