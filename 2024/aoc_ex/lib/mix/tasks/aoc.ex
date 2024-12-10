defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  alias AdventOfCode.Input

  @impl Mix.Task
  def run(args) do
    day = Enum.at(args, 0) |> String.pad_leading(2, "0")

    part =
      args
      |> Enum.find_index(&(&1 == "-p"))
      |> then(&((is_number(&1) && Enum.at(args, &1 + 1)) || "1"))

    test = Enum.any?(args, &(&1 == "-t"))

    input =
      (test && Input.get_test!(String.to_integer(day))) || Input.get!(String.to_integer(day))

    module_name =
      String.to_atom("Elixir.AdventOfCode.Solutions.Day#{day}")

    func = ("part_" <> String.pad_leading(part, 2, "0")) |> String.to_atom()
    parsed = apply(module_name, String.to_atom("parse"), [input])

    IO.inspect(apply(module_name, func, [parsed]),
      label: "Result #{day}/#{part}",
      charlists: :as_lists
    )
  end
end
