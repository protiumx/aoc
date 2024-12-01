module Stdsys = Sys
open Core
open Lwt
open Cohttp_lwt_unix
module CharSet = Set.Make (Char)
module IntSet = Hash_set.Make (Int)

module IntPair = struct
  module T = struct
    type t = int * int

    let compare x y = Tuple2.compare ~cmp1:Int.compare ~cmp2:Int.compare x y
    let sexp_of_t = Tuple2.sexp_of_t Int.sexp_of_t Int.sexp_of_t
    let t_of_sexp = Tuple2.t_of_sexp Int.t_of_sexp Int.t_of_sexp
    let hash = Hashtbl.hash
  end

  include T
  include Comparable.Make (T)
end

module PointHashtbl = Hashtbl.Make (IntPair)
module PointSet = Hash_set.Make (IntPair)

let range_foldi (start, stop) ~init ~f =
  let rec aux i acc =
    if i = stop then
      acc
    else
      aux (i + 1) (f i acc)
  in
  aux start init

let range_fold (start, stop) ~init ~f = range_foldi (start, stop) ~init ~f:(fun _ acc -> f acc)

let range_fold_while (start, stop) ~init ~f =
  List.range start stop |> List.fold_until ~init ~f ~finish:(fun acc -> acc)

let range_iter ?(stride = 1) (start, stop) f = List.range ~stride start stop |> List.iter ~f
let range_intersection (x1, y1) (x2, y2) = max x1 x2 <= min y1 y2
let directions = [ (0, 1); (0, -1); (1, 0); (-1, 0); (1, 1); (1, -1); (-1, 1); (-1, -1) ]
let directions_4 = [ (0, 1); (0, -1); (1, 0); (-1, 0) ]

let read_file file =
  Stdio.In_channel.with_file file ~f:(fun channel -> In_channel.input_all channel)

let read_lines_from file =
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

(* applies least common multiple to a list *)
let llcm list = List.fold list ~init:1 ~f:lcm
let input_path day = Filename.concat "../input" (Printf.sprintf "%d.txt" day)

(** [numbers_from_string s] collects all numbers in s *)
let numbers_from_string (s : string) =
  let zero = int_of_char '0' in
  let rec inner s current =
    match s with
    | [] -> [ current ]
    | h :: t when Char.is_digit h -> inner t ((current * 10) + (int_of_char h - zero))
    | _ :: t when current > 0 -> current :: inner t 0
    | _ :: t -> inner t current
  in
  inner (String.to_list s) 0

let download_input day =
  let session = Printf.sprintf "session=%s" (Sys.getenv_exn "aoc_session") in
  let body =
    Lwt_main.run
      ( Client.get
          ~headers:(Http.Header.init_with "cookie" session)
          (Uri.of_string (Printf.sprintf "https://adventofcode.com/2024/day/%d/input" day))
      >>= fun (_, body) -> body |> Cohttp_lwt.Body.to_string )
  in
  Core.Out_channel.write_all ~data:body (input_path day);
  body

let get_input day =
  let path = input_path day in
  match Stdsys.file_exists path with
  | true -> read_file path
  | false -> download_input day

let get_test_input day = read_file (input_path day ^ ".test")
