defmodule AdventOfCode do
end

defmodule AdventOfCode.Grid do
  @dirs [{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}]
  @dirs_diagonal [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
  @dirs_cross [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]

  def dirs, do: @dirs
  def dirs_diagonal, do: @dirs_diagonal
  def dirs_cross, do: @dirs_cross

  @doc """
  Returns {%{{r, c}: v}, {rows, cols}}
  """
  def load_from_text(s, transform \\ &{:ok, &1}) do
    s = String.split(s, "\n", trim: true) |> Enum.map(&String.to_charlist/1)

    g =
      for {row, r} <- Enum.with_index(s),
          {col, c} <- Enum.with_index(row),
          reduce: %{} do
        acc ->
          case transform.(col) do
            {:ok, x} -> Map.put(acc, {r, c}, x)
            _ -> acc
          end
      end

    {g, {length(s), length(Enum.at(s, 0))}}
  end

  def in_bounds(grid, {x, y}),
    do: x >= 0 && x < length(grid) && y >= 0 && y < length(Enum.at(grid, 0))
end
