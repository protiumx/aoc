open Core
module CharSet = Set.Make (Char)

let range_fold (start, stop) ~(init : 'b) ~(f : 'a -> 'b -> 'b) =
  let rec aux start stop f acc =
    if start = stop then
      acc
    else
      aux (start + 1) stop f (f start acc)
  in
  aux start stop f init

let range_iter start stop f = List.range start stop |> List.iter ~f
let directions = [ (0, 1); (0, -1); (1, 0); (-1, 0); (1, 1); (1, -1); (-1, 1); (-1, -1) ]
let directions_4 = [ (0, 1); (0, -1); (1, 0); (-1, 0) ]

let read_file file =
  Stdio.In_channel.with_file file ~f:(fun channel -> In_channel.input_all channel)

let read_lines file =
  Stdio.In_channel.with_file file ~f:(fun channel ->
      let x = In_channel.input_all channel in
      String.split_lines x)

let matrix_nth matrix x y = List.nth_exn (List.nth_exn matrix x) y
let matrix_size matrix = (List.length matrix, List.length (List.hd_exn matrix))
let matrix_in_bounds rows cols x y = x >= 0 && x < rows && y >= 0 && y < cols

let split_once ch str =
  let[@ocaml.warning "-8"] [ left; right ] = String.split ~on:ch str in
  (left, right)

let rec gcd u v = if v <> 0 then gcd v (u mod v) else abs u

let lcm m n =
  match (m, n) with
  | 0, _ | _, 0 -> 0
  | m, n -> abs (m * n) / gcd m n

let llcm list = List.fold list ~init:1 ~f:lcm
