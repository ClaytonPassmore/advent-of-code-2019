defmodule Day1.Part2 do
  @doc """
    Return 0 for any item less than 9 because item / 3 - 2 will be <= 0.
  """
  def compute_item(item) when item < 9 do
    0
  end

  @doc """
    1. Divide the integer by 3
    2. Truncate it (round it down)
    3. Subtract 2
    4. Recurse and sum that to the result.
  """
  def compute_item(item) do
    result = item
      |> Kernel./(3)
      |> trunc
      |> Kernel.-(2)

    result + compute_item(result)
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


Day1.Part2.compute |> IO.puts
