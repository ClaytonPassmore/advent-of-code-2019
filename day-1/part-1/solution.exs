defmodule Day1.Part1 do
  @doc """
    1. Divide the integer by 3
    2. Truncate it (round it down)
    3. Subtract 2.
  """
  def compute_item(item) do
    item
    |> Kernel./(3)
    |> trunc
    |> Kernel.-(2)
  end

  @doc """
    1. Read the input
    2. Convert each line to an integer
    3. Compute the value of each integer
    4. Sum it up!
  """
  def compute do
    File.read!("input.txt")
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&compute_item/1)
    |> Enum.sum
  end
end


Day1.Part1.compute |> IO.puts
