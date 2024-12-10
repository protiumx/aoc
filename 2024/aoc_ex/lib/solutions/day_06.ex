defmodule AdventOfCode.Solutions.Day06 do
  @dirs [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def parse(input) do
    AdventOfCode.Grid.load_from_text(input, fn ch ->
      case ch do
        ?# -> {:ignore}
        _ -> {:ok, ch}
      end
    end)
  end

  def part_01({grid, {rows, cols}}) do
    start = grid |> Map.filter(fn {_, ch} -> ch == ?^ end) |> Map.keys() |> Enum.at(0)

    grid
    |> walk_grid(start, 0, rows, cols, %{start => 1})
    |> length()
  end

  def part_02({grid, {rows, cols}}) do
    start = grid |> Map.filter(fn {_, ch} -> ch == ?^ end) |> Map.keys() |> Enum.at(0)

    grid
    |> walk_grid(start, 0, rows, cols, %{start => 1})
    |> Enum.filter(&(&1 != start))
    |> Enum.map(fn pos ->
      grid
      |> Map.delete(pos)
      |> walk_grid(start, 0, rows, cols, %{start => 1})
    end)
    |> Enum.filter(fn r -> r == false end)
    |> Enum.count()
  end

  def walk_grid(grid, pos, dir, rows, cols, visited) do
    next = {x, y} = next_pos(pos, dir)

    cond do
      Map.has_key?(grid, next) ->
        walk_grid(grid, next, dir, rows, cols, Map.update(visited, next, 1, &(&1 + 1)))

      # guard went outside?
      x < 0 or y < 0 or x >= rows or y >= cols ->
        Map.keys(visited)

      # assume that 4 iterations means guard passed by pos having 4 different positions
      visited |> Map.values() |> Enum.any?(&(&1 > 4)) ->
        false

      true ->
        walk_grid(grid, pos, turn(dir), rows, cols, visited)
    end
  end

  def turn(dir), do: rem(dir + 1, 4)

  def next_pos({r, c}, dir) do
    {i, j} = Enum.at(@dirs, dir)
    {r + i, c + j}
  end
end
