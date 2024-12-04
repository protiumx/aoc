defmodule AdventOfCode.Solutions.Day03 do
  def parse(input), do: input

  def part_01(code) do
    parse_code(code, %{acc: 0, cond: false, do: true, op: nil, num: nil})
  end

  def part_02(code) do
    parse_code(code, %{acc: 0, cond: true, do: true, op: nil, num: nil})
  end

  defp consume_num(<<x>> <> xs, state) when x in ?0..?9 do
    n = ((is_nil(state.num) && 0) || state.num) * 10
    consume_num(xs, Map.replace(state, :num, n + x - ?0))
  end

  defp consume_num(s, state), do: consume_mul(s, state)

  # Handle (a, b)
  defp consume_mul("(" <> xs, %{op: nil} = state),
    do: consume_num(xs, Map.merge(state, %{num: nil, op: {}}))

  defp consume_mul("," <> xs, state) when is_number(state.num),
    do: consume_num(xs, Map.merge(state, %{num: nil, op: {state.num}}))

  defp consume_mul(")" <> xs, %{op: {a}} = state) when is_number(state.num),
    do: parse_code(xs, Map.merge(state, %{op: nil, num: nil, acc: state.acc + a * state.num}))

  defp consume_mul(s, state), do: parse_code(s, Map.merge(state, %{op: nil, num: nil}))

  # Handle "mul" and conditions
  defp parse_code("", state), do: state.acc

  defp parse_code("don't" <> xs, %{cond: true} = state),
    do: parse_code(xs, Map.replace(state, :do, false))

  defp parse_code("do" <> xs, %{cond: true} = state),
    do: parse_code(xs, Map.replace(state, :do, true))

  defp parse_code("mul" <> xs, %{do: true} = state), do: consume_mul(xs, state)

  defp parse_code(<<_>> <> xs, state), do: parse_code(xs, state)
end
