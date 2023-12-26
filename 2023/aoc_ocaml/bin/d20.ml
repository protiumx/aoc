open Core

let lines = AOC.read_lines "input/d20.in"

module Module = struct
  type t = {
    name : string;
    kind : char;
    dest : string list;
    mem : (string, bool) Hashtbl.t; (* store last state of all inputs *)
    state : bool;
  }

  let make line =
    let name, destinations = AOC.split_once '>' line in
    let name = String.drop_suffix name 2 in
    let dest = String.split destinations ~on:',' |> List.map ~f:String.strip in
    let mem = Hashtbl.create (module String) in
    let state = false in
    if String.(name = "broadcaster") then
      { name; kind = 'b'; dest; mem; state }
    else
      let kind = name.[0] in
      let name = String.drop_prefix name 1 in
      { name; kind; dest; mem; state }
end

let process_module (m : Module.t) origin pulse modules q =
  let pulse =
    match m.kind with
    | '%' when not pulse ->
        let m = { m with state = not m.state } in
        Hashtbl.set modules ~key:m.name ~data:m;
        Some m.state
    | '&' ->
        Hashtbl.set m.mem ~key:origin ~data:pulse;
        Some (not (Hashtbl.for_all m.mem ~f:(Bool.equal true)))
    | _ -> None
  in
  match pulse with
  | Some p -> List.iter m.dest ~f:(fun dest -> Queue.enqueue q (m.name, dest, p))
  | None -> ()

let part_1 =
  let modules = Hashtbl.create (module String) in
  List.iter lines ~f:(fun line ->
      let m = Module.make line in
      Hashtbl.set modules ~key:m.name ~data:m);

  Hashtbl.iter
    ~f:(fun (m : Module.t) ->
      List.iter m.dest ~f:(fun dest ->
          match Hashtbl.find modules dest with
          | Some dest_module when Char.(dest_module.kind = '&') ->
              Hashtbl.add_exn dest_module.mem ~key:m.name ~data:false
          | _ -> ()))
    modules;

  let rec propagate q low high =
    if Queue.is_empty q then
      (low, high)
    else
      let origin, target, pulse = Queue.dequeue_exn q in
      let low, high = if not pulse then (low + 1, high) else (low, high + 1) in
      let () =
        match Hashtbl.find modules target with
        | Some m -> process_module m origin pulse modules q
        | None -> ()
      in
      propagate q low high
  in

  let low, high =
    AOC.range_fold (0, 1000) ~init:(0, 0) ~f:(fun (low, high) ->
        let low = low + 1 in
        let q = Queue.create () in
        let broadcaster = Hashtbl.find_exn modules "broadcaster" in
        List.iter broadcaster.dest ~f:(fun dest -> Queue.enqueue q ("broadcaster", dest, false));
        propagate q low high)
  in
  Fmt.pr "@.Part 1: %d" (low * high)

let part_2 =
  let modules = Hashtbl.create (module String) in
  (* assumption: the input of rx is type & so it needs all of its inputs in high to send a low pulse *)
  let rx_input =
    List.fold lines ~init:"" ~f:(fun acc line ->
        let m = Module.make line in
        Hashtbl.set modules ~key:m.name ~data:m;
        if List.find m.dest ~f:(String.equal "rx") |> Option.is_some then
          m.name
        else
          acc)
  in
  Hashtbl.iter modules ~f:(fun (m : Module.t) ->
      List.iter m.dest ~f:(fun dest ->
          match Hashtbl.find modules dest with
          | Some dest_module when Char.(dest_module.kind = '&') ->
              Hashtbl.set dest_module.mem ~key:m.name ~data:false
          | _ -> ()));

  let cycles = Hashtbl.create (module String) in
  let seen = Hashtbl.create (module String) in

  Hashtbl.iter modules ~f:(fun (m : Module.t) ->
      if List.find m.dest ~f:(String.equal rx_input) |> Option.is_some then
        Hashtbl.set seen ~key:m.name ~data:false);

  let rec propagate q presses =
    if Queue.is_empty q then
      false
    else
      let origin, target, pulse = Queue.dequeue_exn q in
      let break =
        match Hashtbl.find modules target with
        | Some m ->
            let break =
              if String.(m.name = rx_input) && pulse then (
                Hashtbl.set seen ~key:origin ~data:true;
                if not (Hashtbl.mem cycles origin) then
                  Hashtbl.set cycles ~key:origin ~data:presses;
                Hashtbl.for_all seen ~f:(Bool.equal true))
              else
                false
            in
            if break then
              break
            else (
              process_module m origin pulse modules q;
              false)
        | None -> false
      in
      break || propagate q presses
  in

  let rec solve presses =
    let presses = presses + 1 in
    let q = Queue.create () in
    let broadcaster = Hashtbl.find_exn modules "broadcaster" in
    List.iter broadcaster.dest ~f:(fun dest -> Queue.enqueue q ("broadcaster", dest, false));
    if propagate q presses then
      ()
    else
      solve presses
  in
  solve 0;
  Hashtbl.fold cycles ~init:[] ~f:(fun ~key:_ ~data acc -> data :: acc)
  |> AOC.llcm
  |> Fmt.pr "@.Part 2: %d"

let () =
  part_1;
  part_2
