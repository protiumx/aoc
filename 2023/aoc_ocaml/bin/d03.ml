open Core

let lines = AOC.read_lines "input/d03.in"
let matrix = List.map lines ~f:String.to_list
let rows, cols = AOC.matrix_size matrix
let in_bounds x y = AOC.matrix_in_bounds rows cols x y

module IntSet = Stdlib.Set.Make (Int)
module Hashtbl = Stdlib.Hashtbl

let part_1 =
  let rec collect (x, y) acc has_part current_num =
    if x >= rows then acc
    else if y >= cols then
      let acc = if has_part then acc + current_num else acc in
      collect (x + 1, 0) acc false 0
    else
      let current = AOC.matrix_nth matrix x y in
      match Char.is_digit current with
      | true ->
          let current_num = (current_num * 10) + (int_of_char current - int_of_char '0') in
          let has_part =
            has_part
            || List.fold AOC.directions ~init:false ~f:(fun valid (i, j) ->
                   let row, col = (x + i, y + j) in
                   if not (in_bounds row col) then valid
                   else
                     match AOC.matrix_nth matrix row col with
                     | '.' | '0' .. '9' -> valid
                     | _ -> true)
          in
          collect (x, y + 1) acc has_part current_num
      | false ->
          let acc = if has_part then acc + current_num else acc in
          collect (x, y + 1) acc false 0
  in
  collect (0, 0) 0 false 0 |> Fmt.pr "@.Part 2: %d@."

let part_2 =
  let nums_map = Hashtbl.create (List.length matrix) in

  let update_nums gears num =
    if num > 0 then
      IntSet.iter
        (fun gear ->
          let l =
            match Hashtbl.find_opt nums_map gear with
            | Some l -> l
            | None -> []
          in
          Hashtbl.replace nums_map gear (num :: l))
        gears
  in

  let rec collect (x, y) gears current_num =
    if x >= rows then ()
    else if y >= cols then (
      update_nums gears current_num;
      collect (x + 1, 0) IntSet.empty 0)
    else
      let current = AOC.matrix_nth matrix x y in
      let gears, current_num =
        match Char.is_digit current with
        | true ->
            let current_num = (current_num * 10) + (int_of_char current - int_of_char '0') in
            let nearest_gear =
              List.fold AOC.directions ~init:None ~f:(fun op (i, j) ->
                  let row, col = (x + i, y + j) in
                  if not (in_bounds row col) then op
                  else
                    match AOC.matrix_nth matrix row col with
                    | '*' -> Some (row, col)
                    | _ -> op)
            in
            let gears =
              match nearest_gear with
              | Some (gx, gy) -> IntSet.add ((gx * rows) + gy) gears
              | None -> gears
            in
            (gears, current_num)
        | false ->
            update_nums gears current_num;
            (IntSet.empty, 0)
      in
      collect (x, y + 1) gears current_num
  in

  collect (0, 0) IntSet.empty 0;
  Hashtbl.fold
    (fun _ v acc ->
      match List.length v with
      | 2 -> acc + (List.hd_exn v * List.last_exn v)
      | _ -> acc)
    nums_map 0
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
