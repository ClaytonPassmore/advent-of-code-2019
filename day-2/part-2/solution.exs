defmodule Day2.Part2 do
  @target 19690720

  @doc """
    Run the operation for the program at the given offset.
    Recurse with the offset increased by 4.
  """
  def run_operation(program, offset: offset, operation: operation) do
    pos_1 = Enum.at(program, offset + 1)
    pos_2 = Enum.at(program, offset + 2)
    pos_out = Enum.at(program, offset + 3)

    op_1 = Enum.at(program, pos_1)
    op_2 = Enum.at(program, pos_2)

    program
    |> List.replace_at(pos_out, operation.(op_1, op_2))
    |> run_program(offset: offset + 4)
  end

  @doc """
    Run the program at `offset`.
    If the operator is 99, just return the first item.
  """
  def run_program(program, offset: offset) do
    case program |> Enum.at(offset) do
      1 -> run_operation(program, offset: offset, operation: &Kernel.+/2)
      2 -> run_operation(program, offset: offset, operation: &Kernel.*/2)
      99 -> program |> List.first
    end
  end

  @doc """
    Find the first matching input pair to result in our target.
    Output 100 * noun + verb.
  """
  def find_params(program) do
    results = for i <- 0..99, j <- 0..99 do
      new_program = program
        |> List.replace_at(1, i)
        |> List.replace_at(2, j)

      {run_program(new_program, offset: 0), i, j}
    end

    {winner, _} = results |> List.keytake(@target, 0)
    {@target, noun, verb} = winner

    100 * noun + verb
  end

  @doc """
    1. Read the file
    2. Trim out newlines
    3. Split on commas
    4. Convert items to integers
    5. Feed program to `find_params`.
  """
  def compute do
    File.read!("input.txt")
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> find_params
  end
end


Day2.Part2.compute |> IO.puts
