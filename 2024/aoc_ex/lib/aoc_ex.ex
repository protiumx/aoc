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

    parsed = Input.get!(3) |> Solutions.Day03.parse()
    IO.puts("Part 1: #{Solutions.Day03.part_01(parsed)}\n")
    IO.puts("Part 1: #{Solutions.Day03.part_02(parsed)}\n")

    parsed = Input.get_test!(4) |> Solutions.Day04.parse()
    IO.puts("Part 1: #{Solutions.Day04.part_01(parsed)}\n")
    IO.puts("Part 2: #{Solutions.Day04.part_02(parsed)}\n")
  end
end

defmodule AdventOfCode.Grid do
  @dirs [{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}]
  @dirs_diagonal [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
  @dirs_cross [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]

  def dirs, do: @dirs
  def dirs_diagonal, do: @dirs_diagonal
  def dirs_cross, do: @dirs_cross

  @doc """
  Returns %{{r, c}: v}
  """
  def load_from_text(s, transform) when is_function(transform, 1) do
    s = String.split(s, "\n", trim: true) |> Enum.map(&String.to_charlist/1)

    for {row, r} <- Enum.with_index(s),
        {col, c} <- Enum.with_index(row),
        into: %{},
        do: {{r, c}, transform.(col)}
  end

  def in_bounds(grid, {x, y}),
    do: x >= 0 && x < length(grid) && y >= 0 && y < length(Enum.at(grid, 0))
end
