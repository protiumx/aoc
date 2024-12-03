defmodule AdventOfCode do
  alias AdventOfCode.Solutions
  alias AdventOfCode.Input

  def run do
    parsed = Input.get!(1) |> Solutions.Day01.parse()
    IO.puts("Part 1: #{Solutions.Day01.part_01(parsed)}\n")
    IO.puts("Part 2: #{Solutions.Day01.part_02(parsed)}\n")

    parsed = Input.get!(2) |> Solutions.Day02.parse()
    IO.puts("Part 1: #{Solutions.Day02.part_01(parsed)}\n")
    IO.puts("Part 2: #{Solutions.Day02.part_02(parsed)}\n")
  end
end
