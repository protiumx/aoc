open Core

let lines = AOC.read_lines "input/d19.in"

module Hashtbl = Stdlib.Hashtbl

module Rule = struct
  type t = { op : char; n : int; part_type : char; apply : int -> bool; target : string }

  let make s =
    let condition, target = AOC.split_once ':' s in
    let[@ocaml.warning "-8"] (part_type :: op :: n) = String.to_list condition in
    let n = Int.of_string (String.of_char_list n) in
    let apply =
      match op with
      | '>' -> fun x -> x > n
      | _ -> fun x -> x < n
    in
    { op; part_type; n; apply; target }
end

module Workflow = struct
  type t = { name : string; rules : Rule.t list; fallback : string }

  let make s =
    let s = String.drop_suffix s 1 in
    let name, rules = AOC.split_once '{' s in
    let[@ocaml.warning "-8"] (fallback :: rules) = String.split rules ~on:',' |> List.rev in
    let rules = List.fold rules ~init:[] ~f:(fun acc raw -> Rule.make raw :: acc) in
    { name; rules; fallback }
end

let part_1 =
  let workflows = Hashtbl.create 100 in
  let rec collect data =
    match data with
    | hd :: tl when String.(hd = "") -> tl
    | hd :: tl ->
        let w = Workflow.make hd in
        Hashtbl.add workflows w.name w;
        collect tl
    | _ -> assert false
  in

  let parts = collect lines in

  let rec accepted part workflow =
    match workflow with
    | "A" -> true
    | "R" -> false
    | _ -> (
        let workflow = Hashtbl.find workflows workflow in
        (* find the first rule in order *)
        let rule =
          List.find workflow.rules ~f:(fun rule ->
              match Hashtbl.find_opt part rule.part_type with
              | Some rating -> rule.apply rating
              | None -> false)
        in
        match rule with
        | Some r -> accepted part r.target
        | None -> accepted part workflow.fallback)
  in

  List.fold parts ~init:0 ~f:(fun acc part ->
      let data = String.slice part 1 (String.length part - 1) |> String.split ~on:',' in
      let part = Hashtbl.create (List.length data) in

      List.iter data ~f:(fun part_rating ->
          let name, rating = AOC.split_once '=' part_rating in
          Hashtbl.add part name.[0] (Int.of_string rating));

      acc + if accepted part "in" then Hashtbl.fold (fun _ v acc -> acc + v) part 0 else 0)
  |> Fmt.pr "@.Part 1: %d"

let part_2 =
  let workflows = Hashtbl.create 100 in
  let rec collect data =
    match data with
    | hd :: _ when String.(hd = "") -> ()
    | hd :: tl ->
        let w = Workflow.make hd in
        Hashtbl.add workflows w.name w;
        collect tl
    | _ -> assert false
  in
  collect lines;

  let rec count ranges workflow =
    match workflow with
    | "R" -> 0
    | "A" -> Hashtbl.fold (fun _ (low, high) acc -> acc * (high - low + 1)) ranges 1
    | w ->
        let workflow = Hashtbl.find workflows w in
        List.fold_until workflow.rules ~init:(0, ranges)
          ~f:(fun (acc, current_ranges) rule ->
            let low, high = Hashtbl.find current_ranges rule.part_type in

            let (accepted_low, accepted_high), (rejected_low, rejected_high) =
              match rule.op with
              (* accept all in [low, rule.n), reject all in [rule.n, high] *)
              | '<' -> ((low, rule.n - 1), (rule.n, high))
              (* accept all in (rule.n, high], reject all in [low, rule.n] *)
              | _ -> ((rule.n + 1, high), (low, rule.n))
            in

            let acc =
              acc
              +
              if accepted_low <= accepted_high then (
                let current_ranges = Hashtbl.copy current_ranges in
                Hashtbl.replace current_ranges rule.part_type (accepted_low, accepted_high);
                count current_ranges rule.target)
              else
                0
            in
            if rejected_low <= rejected_high then (
              (* continue using the rejected part *)
              Hashtbl.replace current_ranges rule.part_type (rejected_low, rejected_high);
              Continue (acc, current_ranges))
            else (* short circuit: there are no more ranges *)
              Stop (acc, current_ranges))
          ~finish:(fun (acc, current_ranges) ->
            (acc + count current_ranges workflow.fallback, current_ranges))
        |> fst
  in

  let ranges = Hashtbl.create 4 in
  String.iter "xmas" ~f:(fun ch -> Hashtbl.add ranges ch (1, 4000));

  count ranges "in" |> Fmt.pr "@.Part 2: %d"

let () =
  part_1;
  part_2
