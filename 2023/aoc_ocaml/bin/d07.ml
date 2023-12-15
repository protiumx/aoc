[@@@warning "-8"]

open Core
module CharMap = Map.Make (Char)

let lines = AOC.read_lines "input/d07.test"

let hand_scorer = function
  | [ _ ] -> 7
  | [ 4; _ ] -> 6
  | [ 3; _ ] -> 5
  | [ 3; _; _ ] -> 4
  | [ 2; _; _ ] -> 3
  | [ 2; _; _; _ ] -> 2
  | _ -> 1

let char_counter s =
  String.to_list s
  |> List.fold ~init:CharMap.empty ~f:(fun acc ch ->
         Map.update acc ch ~f:(fun v ->
             match v with
             | Some v -> v + 1
             | None -> 1))

module Hand = struct
  type t = { cards : int list; bid : int; score : int }

  let compare a b =
    match Int.compare a.score b.score with
    | 0 -> List.compare Int.compare a.cards b.cards
    | cmp -> cmp

  let make s hand_scorer card_map =
    let cards, bid = AOC.split_once ' ' s in
    let score = hand_scorer cards in
    let cards = List.map (String.to_list cards) ~f:card_map in
    let bid = Int.of_string bid in

    { cards; bid; score }
end

let part_1 =
  let map = function
    | 'T' -> 10
    | 'J' -> 11
    | 'Q' -> 12
    | 'K' -> 13
    | 'A' -> 14
    | ch -> int_of_char ch - int_of_char '0'
  in

  let scorer hand =
    char_counter hand
    |> Map.to_alist
    |> List.map ~f:snd
    |> List.sort ~compare:(fun a b -> compare b a)
    |> hand_scorer
  in

  let hands = List.map lines ~f:(fun l -> Hand.make l scorer map) in
  let hands = List.sort hands ~compare:Hand.compare in
  List.foldi hands ~init:0 ~f:(fun idx acc h -> acc + (h.bid * (idx + 1)))
  |> Fmt.pr "@.Part 1: %d@."

let part_2 =
  let map = function
    | 'J' -> 1
    | 'T' -> 10
    | 'Q' -> 12
    | 'K' -> 13
    | 'A' -> 14
    | ch -> Int.of_string (String.of_char ch)
  in

  let scorer cards =
    let counts =
      char_counter cards
      |> Map.to_alist
      |> List.sort ~compare:(fun (_, a) (_, b) -> Int.compare b a)
    in
    let jokers, counts =
      List.partition_map counts ~f:(fun (card, count) ->
          match card with
          | 'J' -> Either.First count
          | _ -> Either.Second count)
    in
    let jokers = List.hd jokers |> Option.value ~default:0 in
    match (jokers, counts) with
    | 5, _ -> 7
    (* e.g. JJ112 -> 11112 -> [4; 1] -> 6 *)
    | jokers, hd :: tail -> hand_scorer ((hd + jokers) :: tail)
    | _ -> assert false
  in

  let hands =
    List.map lines ~f:(fun l -> Hand.make l scorer map) |> List.sort ~compare:Hand.compare
  in
  List.foldi hands ~init:0 ~f:(fun idx acc h -> acc + (h.bid * (idx + 1)))
  |> Fmt.pr "@.Part 2: %d@."

let () =
  part_1;
  part_2
