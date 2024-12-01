defmodule AdventOfCode.Solutions.Day01 do
  def parse(input) do
    input
    # split by empty spaces leaving numbers only
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> then(
      # a function & that return a list of lists
      &[
        _left = Enum.take_every(&1, 2),
        _right = Enum.take_every(tl(&1), 2)
      ]
    )
  end

  def part_01(cols) do
    cols
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.reduce(0, fn {l, r}, acc ->
      acc + abs(l - r)
    end)
  end

  def part_02([left, right]) do
    rfreq = Enum.frequencies(right)

    left
    |> Enum.reduce(0, fn l, acc ->
      acc + l * Map.get(rfreq, l, 0)
    end)
  end
end
