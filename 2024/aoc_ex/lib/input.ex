defmodule AdventOfCode.Input do
  @doc """
  Download input files and store them locally
  """

  def get!(day) do
    cond do
      in_cache?(day) ->
        from_cache!(day)

      true ->
        download!(day)
    end
  end

  def get_test!(day) do
    File.read!(cache_path(day) <> ".test")
  end

  def delete!(day), do: File.rm!(cache_path(day))

  defp in_cache?(day), do: File.exists?(cache_path(day))

  defp cache_path(day), do: Path.join("../input", "#{day}.txt")

  defp store_in_cache!(day, input) do
    path = cache_path(day)
    :ok = path |> Path.dirname() |> File.mkdir_p()
    :ok = File.write(path, input)
  end

  defp from_cache!(day), do: File.read!(cache_path(day))

  defp download!(day) do
    HTTPoison.start()

    {:ok, %{status_code: 200, body: input}} =
      HTTPoison.get("https://adventofcode.com/2023/day/#{day}/input", headers())

    store_in_cache!(day, input)

    to_string(input)
  end

  defp headers, do: [cookie: "session=" <> System.get_env("aoc_session")]
end
