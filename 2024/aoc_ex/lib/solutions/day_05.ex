defmodule AdventOfCode.Solutions.Day05 do
  def parse(input) do
    [rules, updates] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split(["\n", "|"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> {a, b} end)
      |> MapSet.new()

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  def part_01({rules, updates}) do
    updates
    |> Enum.filter(&valid_update?(rules, &1))
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def part_02({rules, updates}) do
    updates
    |> Enum.filter(&(not valid_update?(rules, &1)))
    |> Enum.map(&fix_update(rules, &1))
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  defp pair_up(_, [], acc), do: acc

  defp pair_up(elem, [x | xs], acc) do
    pair_up(elem, xs, [{elem, x} | acc])
  end

  defp fix_update(rules, update) do
    update
    |> Enum.map(fn page ->
      {page, Enum.count(pair_up(page, update, []), &(&1 in rules))}
    end)
    |> Enum.sort(fn {_, a}, {_, b} -> b <= a end)
    |> Enum.map(&elem(&1, 0))
  end

  defp valid_update?(rules, update) do
    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a, b] -> {a, b} not in rules end)
    |> Kernel.not()
  end

  defp middle(l), do: Enum.at(l, div(length(l), 2))
end
