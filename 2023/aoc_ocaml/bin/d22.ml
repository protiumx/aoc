[@@@warning "-8"]

open Core

let lines = AOC.read_lines "input/d22.in"

module IntSet = Hash_set.Make (Int)

let get_bricks () =
  List.map lines ~f:(fun line ->
      let a, b = AOC.split_once '~' line in
      let [ ax; ay; az ] = String.split a ~on:',' in
      let [ bx; by; bz ] = String.split b ~on:',' in
      let x1, y1, z1 = (Int.of_string ax, Int.of_string ay, Int.of_string az) in
      let x2, y2, z2 = (Int.of_string bx, Int.of_string by, Int.of_string bz) in
      (x1, y1, z1, x2, y2, z2))
  |> List.sort ~compare:(fun (_, _, z1, _, _, _) (_, _, z2, _, _, _) -> Int.compare z1 z2)
  |> Array.of_list

let bricks_overlap (ax1, ay1, _, ax2, ay2, _) (bx1, by1, _, bx2, by2, _) =
  AOC.range_inter (ax1, ax2) (bx1, bx2) && AOC.range_inter (ay1, ay2) (by1, by2)

let find_bricks_supports bricks =
  let len = Array.length bricks in
  (* drop bricks the farthest on Z axis *)
  Array.iteri bricks ~f:(fun i brick ->
      let max_z =
        AOC.range_foldi (0, i) ~init:1 ~f:(fun j acc ->
            let check = bricks.(j) in
            if bricks_overlap brick check then
              let _, _, _, _, _, z = check in
              max acc (z + 1)
            else
              acc)
      in
      let x1, y1, z1, x2, y2, z2 = brick in
      bricks.(i) <- (x1, y1, max_z, x2, y2, z2 - (z1 - max_z)));

  Array.sort bricks ~compare:(fun (_, _, z1, _, _, _) (_, _, z2, _, _, _) -> Int.compare z1 z2);

  let a_supports_b = Array.init len ~f:(fun _ -> IntSet.create ()) in
  let b_supports_a = Array.init len ~f:(fun _ -> IntSet.create ()) in

  Array.iteri bricks ~f:(fun j upper ->
      AOC.range_iter (0, j) (fun i ->
          let lower = bricks.(i) in
          let _, _, z1, _, _, _ = upper in
          let _, _, _, _, _, z2 = lower in
          (* if bricks overlaps and upper is right above lower *)
          if bricks_overlap lower upper && z1 = z2 + 1 then (
            Hash_set.add a_supports_b.(i) j;
            Hash_set.add b_supports_a.(j) i)));

  (a_supports_b, b_supports_a)

let part_1 =
  let bricks = get_bricks () in
  let bricks_length = Array.length bricks in

  let a_supports_b, b_supports_a = find_bricks_supports bricks in
  AOC.range_foldi (0, bricks_length) ~init:0 ~f:(fun i acc ->
      (* if all the bricks supported by i have at least 2 other supports then i can be disintegrated *)
      if Hash_set.for_all a_supports_b.(i) ~f:(fun j -> Hash_set.length b_supports_a.(j) >= 2) then
        acc + 1
      else
        acc)
  |> Fmt.pr "@.Part 1: %d"

let part_2 =
  let bricks = get_bricks () in

  let a_supports_b, b_supports_a = find_bricks_supports bricks in
  AOC.range_foldi
    (0, Array.length bricks)
    ~init:0
    ~f:(fun i acc ->
      (* disintegrate all bricks supported by i that only that only have i as support *)
      let supported =
        Hash_set.to_list a_supports_b.(i)
        |> List.filter ~f:(fun j -> Hash_set.length b_supports_a.(j) = 1)
      in
      let q = Queue.of_list supported in
      let falling = IntSet.of_list supported in
      Hash_set.add falling i;

      while not (Queue.is_empty q) do
        let j = Queue.dequeue_exn q in
        Hash_set.iter
          (* diff/subtraction is same as doing not (Set.mem) *)
          (Hash_set.diff a_supports_b.(j) falling)
          ~f:(fun k ->
            (* check if k is not supported by anything (all falling) *)
            if
              Hash_set.length (Hash_set.inter b_supports_a.(k) falling)
              = Hash_set.length b_supports_a.(k)
            then (
              (* k is no longer supported *)
              Queue.enqueue q k;
              Hash_set.add falling k))
      done;

      acc + Hash_set.length falling - 1)
  |> Fmt.pr "@.Part 2: %d"

let () =
  part_1;
  part_2
