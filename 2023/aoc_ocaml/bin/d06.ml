open Core

let lines = AOC.read_lines "input/d06.in"
let zero = int_of_char '0'

type quadroots = RealRoots of float * float | ComplexRoots of Complex.t * Complex.t

let solve_quadratic a b c =
  let d = (b *. b) -. (4.0 *. a *. c) in
  if Float.(d < 0.0) then
    let r = -.b /. (2.0 *. a) and i = sqrt (-.d) /. (2.0 *. a) in
    ComplexRoots ({ Complex.re = r; Complex.im = i }, { Complex.re = r; Complex.im = -.i })
  else
    let r = if Float.(b < 0.0) then (sqrt d -. b) /. (2.0 *. a) else (sqrt d +. b) /. (-2.0 *. a) in
    RealRoots (r, c /. (r *. a))

let rec collect_numbers line current to_end =
  match line with
  | [] -> [ current ]
  | h :: t when Char.is_digit h ->
      collect_numbers t ((current * 10) + (int_of_char h - zero)) to_end
  | _ :: t when (not to_end) && current > 0 -> current :: collect_numbers t 0 to_end
  | _ :: t -> collect_numbers t current to_end

let part_1 =
  let times = collect_numbers (String.to_list (List.nth_exn lines 0)) 0 false in
  let records = collect_numbers (String.to_list (List.nth_exn lines 1)) 0 false in
  List.foldi records ~init:1 ~f:(fun idx acc r ->
      let b = Float.of_int (List.nth_exn times idx) in
      let c = Float.of_int (-r) in
      match solve_quadratic (-1.0) b c with
      | RealRoots (x1, x2) -> acc * Int.of_float (Float.round_up x1 -. Float.round_down x2 -. 1.0)
      | _ -> acc)
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let time = collect_numbers (String.to_list (List.nth_exn lines 0)) 0 true |> List.hd_exn in
  let record = collect_numbers (String.to_list (List.nth_exn lines 1)) 0 true |> List.hd_exn in

  let b = Float.of_int time in
  let c = Float.of_int (-record) in
  let ways =
    match solve_quadratic (-1.0) b c with
    | RealRoots (x1, x2) -> Int.of_float (Float.round_up x1 -. Float.round_down x2 -. 1.0)
    | _ -> 0
  in

  Fmt.pr "@.Part 2: %d@." ways

let () =
  part_1;
  part_2
