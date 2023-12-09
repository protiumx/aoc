open Core

let range_iter start stop f = List.range start stop |> List.iter ~f
let directions = [ (0, 1); (0, -1); (1, 0); (-1, 0); (1, 1); (1, -1); (-1, 1); (-1, -1) ]

let read_lines file =
  Stdio.In_channel.with_file file ~f:(fun channel ->
      let x = In_channel.input_all channel in
      String.split_lines x)

let matrix_nth matrix x y = List.nth_exn (List.nth_exn matrix x) y
let matrix_size matrix = (List.length matrix, List.length (List.hd_exn matrix))
let matrix_in_bounds rows cols x y = x >= 0 && x < rows && y >= 0 && y < cols
