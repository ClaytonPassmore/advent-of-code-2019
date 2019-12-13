defmodule Day6.Part2 do
  @doc """
    Turn a list of orbit strings into a hash map.
    [ "A)B" ] => %{ B => A }
  """
  def parse_orbits(orbits) do
    orbits
    |> Enum.map(fn x -> String.split(x, ")") end)
    |> Enum.reduce(%{}, fn [ inner, outer ], acc -> Map.put(acc, outer, inner) end)
  end

  def trace_path(orbits, key, dest \\ nil, acc \\ []) do
    orbiting = Map.get(orbits, key)

    cond do
      orbiting == dest -> [key | acc ]
      true -> trace_path(orbits, orbiting, dest, [ key | acc ])
    end
  end

  def least_common_ancestor(path1, path2) when path1 == nil or path2 == nil do
    nil
  end

  def least_common_ancestor(path1, path2) do
    [ item1 | path1_tail ] = path1
    [ item2 | path2_tail ] = path2

    path1_tail = if Enum.count(path1_tail) == 0, do: nil, else: path1_tail
    path2_tail = if Enum.count(path2_tail) == 0, do: nil, else: path2_tail

    cond do
      item1 == item2 -> least_common_ancestor(path1_tail, path2_tail) || item1
      true -> nil
    end
  end

  def compute do
    orbits = File.read!("input.txt")
      |> String.split
      |> parse_orbits

    path_to_you = trace_path(orbits, "YOU")
    path_to_santa = trace_path(orbits, "SAN")

    ancestor = least_common_ancestor(path_to_you, path_to_santa)

    a_path_to_you = trace_path(orbits, "YOU", ancestor)
    a_path_to_santa = trace_path(orbits, "SAN", ancestor)

    path = Enum.reverse(a_path_to_you) ++ [ancestor] ++ a_path_to_santa

    # Count the transfers between objects between YOU and SAN, not including.
    # -2 to account for YOU and SAN
    # -1 to account for transfers rather than objects
    Enum.count(path) - 2 - 1
  end
end


Day6.Part2.compute |> IO.inspect
