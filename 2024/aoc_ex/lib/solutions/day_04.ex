defmodule AdventOfCode.Solutions.Day04 do
  def parse(input) do
    AdventOfCode.Grid.load_from_text(input, & &1)
  end

  def part_01(grid) do
    grid
    |> search_points(?X)
    |> Enum.map(fn {r, c} ->
      Enum.count(AdventOfCode.Grid.dirs(), fn {i, j} ->
        ~c"XMAS"
        |> Enum.with_index()
        |> Enum.all?(fn {ch, offset} ->
          grid[{r + offset * i, c + offset * j}] == ch
        end)
      end)
    end)
    |> Enum.sum()
  end

  def part_02(grid) do
    grid
    |> search_points(?A)
    |> Enum.count(fn {r, c} ->
      # M   S | S   M |   A   |   A
      #   A   |   A   | S   M | M   S
      [grid[{r - 1, c - 1}], grid[{r + 1, c + 1}]] in [~c"MS", ~c"SM"] and
        [grid[{r - 1, c + 1}], grid[{r + 1, c - 1}]] in [~c"MS", ~c"SM"]
    end)
  end

  defp search_points(grid, ch) do
    grid
    |> Map.keys()
    |> Enum.filter(&Kernel.==(grid[&1], ch))
  end
end
