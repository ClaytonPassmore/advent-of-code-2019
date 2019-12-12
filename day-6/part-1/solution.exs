defmodule Day6.Part1 do
  @doc """
    Turn a list of orbit strings into a hash map.
    [ "A)B" ] => %{ B => A }
  """
  def parse_orbits(orbits) do
    orbits
    |> Enum.map(fn x -> String.split(x, ")") end)
    |> Enum.reduce(%{}, fn [ inner, outer ], acc -> Map.put(acc, outer, inner) end)
  end

  def count_orbits(orbits) do
    orbits
    |> Map.keys
    |> Enum.map(fn key -> count_orbit_path(orbits, key) end)
    |> Enum.sum
  end

  @doc """
    Recursively counts the number of orbits from the given object.
  """
  def count_orbit_path(orbits, key) do
    orbiting = Map.get(orbits, key)

    cond do
      orbiting == nil -> 0
      true -> 1 + count_orbit_path(orbits, orbiting)
    end
  end

  @doc """
    Read the file, parse each orbit, then count each orbit.
  """
  def compute do
    File.read!("input.txt")
    |> String.split
    |> parse_orbits
    |> count_orbits
  end
end


Day6.Part1.compute |> IO.puts
