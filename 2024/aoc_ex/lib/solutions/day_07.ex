defmodule AdventOfCode.Solutions.Day07 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, [" ", ":"], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_01(tests) do
    solve(tests, [:+, :*])
  end

  def part_02(tests) do
    solve(tests, [:+, :*, :||])
  end

  defp solve(tests, operands) do
    tests
    |> Enum.filter(fn [x | xs] ->
      is_valid?(xs, operands, x, 0)
    end)
    |> Enum.map(&hd(&1))
    |> Enum.sum()
  end

  defp is_valid?([], _, target, acc), do: target == acc

  defp is_valid?([x | xs], operations, target, acc) do
    operations
    |> Enum.any?(fn op ->
      is_valid?(xs, operations, target, do_op(op, acc, x))
    end)
  end

  defp do_op(:+, a, b), do: a + b
  defp do_op(:*, a, b), do: a * b
  defp do_op(:||, a, b), do: a * 10 ** (1 + trunc(:math.log10(b))) + b
end
