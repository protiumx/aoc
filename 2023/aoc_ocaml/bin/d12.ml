open Core

let lines = AOC.read_lines "input/d12.in"

module Hashtbl = Stdlib.Hashtbl

(* let rec take l n acc = *)
(*   match l with *)
(*   | [] -> (acc, []) *)
(*   | h :: t when n <= 0 && Char.(h = '?' || h = '.') -> (h :: acc, t) *)
(*   | h :: t -> take t (n - if Char.(h = '.') then 0 else 1) (h :: acc) *)
let rec count_ways condition arrangements i j mem =
  match (condition, arrangements) with
  | [], [] -> 1 (* we fit last group into the arrangement *)
  | [], _ -> 0 (* invalid: there are no more conditions to fit the remaining arrangements *)
  | c, [] ->
      if List.find c ~f:(Char.equal '#') |> Option.is_some then
        0 (* invalid: there are broken springs left but no arrangements *)
      else
        1
  | _, _ when Hashtbl.mem mem (i, j) -> Hashtbl.find mem (i, j)
  | c, a ->
      let ch = List.hd_exn c in
      let size = List.hd_exn a in

      let ret = if String.contains ".?" ch then count_ways (List.drop c 1) a (i + 1) j mem else 0 in

      let group_len = List.length c in
      let current_group = List.take c size in
      (* check if we finished a group and start next *)
      let ret =
        if
          String.contains "#?" ch
          && size <= group_len
          && List.find current_group ~f:(Char.equal '.') |> Option.is_none
          && (size = group_len || not (Char.equal (List.nth_exn c size) '#'))
        then (* +1 accounts for '.' *)
          let next_group = List.drop c (size + 1) in
          ret + count_ways next_group (List.drop a 1) (i + size + 1) (j + 1) mem
        else
          ret
      in
      Hashtbl.add mem (i, j) ret;
      ret

let part_1 =
  List.fold lines ~init:0 ~f:(fun acc line ->
      let condition, arrangement = AOC.split_once ' ' line in
      let arrangement = List.map (String.split arrangement ~on:',') ~f:Int.of_string in
      let condition = String.to_list condition in

      (* let groups, _ = *)
      (*   List.fold arrangement ~init:([], condition) ~f:(fun (acc, con) a -> *)
      (*       let took, rest = take con a [] in *)
      (*       (List.rev took :: acc, rest)) *)
      (* in *)
      let c = count_ways condition arrangement 0 0 (Hashtbl.create 1000) in
      c + acc)
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  List.fold lines ~init:0 ~f:(fun acc line ->
      let condition, arrangement = AOC.split_once ' ' line in
      let conditions =
        AOC.range_fold (0, 5) ~init:"" ~f:(fun acc ->
            String.append condition (if String.is_empty acc then acc else String.append "?" acc))
        |> String.to_list
      in
      let arrangements =
        AOC.range_fold (0, 5) ~init:"" ~f:(fun acc ->
            String.append arrangement (if String.is_empty acc then acc else String.append "," acc))
        |> String.split ~on:','
        |> List.map ~f:Int.of_string
      in

      let c = count_ways conditions arrangements 0 0 (Hashtbl.create 1000) in
      c + acc)
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
