[@@@warning "-8"]
[@@@warning "-69"]

open Core

let lines = AOC.read_lines "input/d24.in"

module Hailstone = struct
  (* represented as lines on a plane *)
  type t = {
    x : int64;
    y : int64;
    z : int64;
    vx : int64;
    vy : int64;
    vz : int64;
    a : int64;
    b : int64;
    c : int64;
  }

  let make line =
    let position, speed = AOC.split_once '@' line in
    let [ x; y; z ] =
      String.split position ~on:',' |> List.map ~f:(fun s -> Int64.of_string (String.strip s))
    in
    let [ vx; vy; vz ] =
      String.split speed ~on:',' |> List.map ~f:(fun s -> Int64.of_string (String.strip s))
    in
    { x; y; z; vx; vy; vz; a = vy; b = Int64.neg vx; c = Int64.((vy * x) - (vx * y)) }

  let intersects (hs1 : t) (hs2 : t) (low, high) =
    (* parallels *)
    if Int64.(hs1.a * hs2.b = hs1.b * hs2.a) then
      false
    else
      let m = Float.of_int64 Int64.((hs1.a * hs2.b) - (hs2.a * hs1.b)) in
      let x = Float.of_int64 Int64.((hs1.c * hs2.b) - (hs2.c * hs1.b)) /. m in
      let y = Float.of_int64 Int64.((hs2.c * hs1.a) - (hs1.c * hs2.a)) /. m in
      (* intersection should happen in the future *)
      let inter =
        Float.(low <= x && x <= high && low <= y && y <= high)
        && List.for_all [ hs1; hs2 ] ~f:(fun h ->
               Float.(
                 (x - Float.of_int64 h.x) * Float.of_int64 h.vx >= 0.0
                 && (y - Float.of_int64 h.y) * Float.of_int64 h.vy >= 0.0))
      in
      inter
end

let hailstones = List.map lines ~f:Hailstone.make |> Array.of_list

let part_1 =
  (* let low = 7.0 in *)
  (* let high = 27.0 in *)
  let low = 200000000000000.0 in
  let high = 400000000000000.0 in
  Array.foldi hailstones ~init:0 ~f:(fun i acc hs1 ->
      Array.fold (Array.slice hailstones 0 i) ~init:acc ~f:(fun acc' hs2 ->
          acc' + Bool.to_int (Hailstone.intersects hs1 hs2 (low, high))))
  |> Fmt.pr "@.Part 1: %d@."

let part_2 = ()

let () =
  part_1;
  part_2
