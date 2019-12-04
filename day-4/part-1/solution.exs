defmodule Day4.Part1 do
  @doc """
    Checks an item against a previous value and sets a flag if their value is the same.
  """
  def is_double(item, acc) do
    { prev, val } = acc

    { item, val || prev == item }
  end

  @doc """
    Checks if a list of digits contain to consecutive digits that are the same value.
  """
  def at_least_one_double?(digits) do
    [ head | tail ] = digits

    acc = { head, false }

    { _, has_double } = tail |> Enum.reduce(acc, &is_double/2)

    has_double
  end

  @doc """
    Checks an item against a previous value and sets a flag if the item is smaller.
  """
  def is_desc(item, acc) do
    { prev, desc } = acc

    { item, desc || item < prev }
  end

  @doc """
    Checks if a list of digits are in non-descending order.
  """
  def non_descending?(digits) do
    [ head | tail ] = digits

    acc = { head, false }
    { _, desc } = tail |> Enum.reduce(acc, &is_desc/2)

    !desc
  end

  @doc """
    Checks if a given number counts as a valid password.
  """
  def valid_pw?(candidate) do
    digits = candidate
       |> Integer.to_string
       |> String.codepoints
       |> Enum.map(&String.to_integer/1)

    non_descending?(digits) && at_least_one_double?(digits)
  end

  @doc """
    Counts the number of valid passwords in the range lower to upper.
  """
  def count_possible_passwords(lower, upper) do
    results = for candidate <- lower..upper, valid_pw?(candidate), do: 1

    results |> Enum.sum
  end

  @doc """
    Read the file and convert the range bounds to integers, then find the
    number of valid passwords in the range.
  """
  def compute do
    [ lower, upper ] = File.read!("input.txt")
      |> String.trim
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    count_possible_passwords(lower, upper)
  end
end


Day4.Part1.compute |> IO.inspect
