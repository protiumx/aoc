defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    IO.puts(AdventOfCode.run())
  end
end
