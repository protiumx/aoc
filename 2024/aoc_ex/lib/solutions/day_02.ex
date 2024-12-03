defmodule AdventOfCode.Solutions.Day02 do
  def parse(input) do
    input
    # split by empty spaces leaving numbers only
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line) |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_01(reports) do
    reports
    |> Enum.count(&is_safe_report?/1)
  end

  def part_02(reports) do
    reports
    |> Enum.count(fn levels ->
      Enum.any?(0..(length(levels) - 1), fn i ->
        levels
        |> List.delete_at(i)
        |> is_safe_report?()
      end)
    end)
  end

  defp direction([a, b | _]) when b - a >= 0, do: 1
  defp direction(_), do: -1

  defp is_safe_report?(levels) do
    levels |> Enum.chunk_every(2, 1, :discard) |> is_safe?(direction(levels))
  end

  defp is_safe?([], _), do: true
  defp is_safe?([[a, b] | _], dir) when ((b - a) * dir) not in 1..3, do: false
  defp is_safe?([_ | xs], dir), do: is_safe?(xs, dir)
end
