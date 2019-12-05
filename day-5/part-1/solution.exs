defmodule Day5.Part1 do
  @doc """
    Split an opcode from parameter modes (if present).
  """
  def get_opcode(op) do
    op_list = op
      |> Integer.to_string
      |> String.codepoints

    # If the op_list contains positional info, slice that off to get the opcode.
    cond do
      (Enum.count(op_list) > 2) -> op_list |> Enum.slice(-2..-1) |> List.to_string |> String.to_integer
      true -> op
    end
  end

  @doc """
    Return a list of parameter modes.
    List may not alway match the number of parameters so Enum.at should be used
    on this list with a default value of 0 to represent the default mode.
  """
  def get_modes(op) do
    op_list = op
      |> Integer.to_string
      |> String.codepoints

    # If the op_list contains positional info, slice the rest off to get the
    # modes. Need to reverse the enum because it's originally right to left.
    cond do
      (Enum.count(op_list) > 2) -> op_list |> Enum.slice(0..-3) |> Enum.map(&String.to_integer/1) |> Enum.reverse
      true -> []
    end
  end

  @doc """
    Run the operation for the program at the given offset.
  """
  def run_operation(program, offset: offset, operation: operation) do
    pos_1 = Enum.at(program, offset + 1)
    pos_2 = Enum.at(program, offset + 2)
    pos_out = Enum.at(program, offset + 3)

    modes = program |> Enum.at(offset) |> get_modes
    op_1_mode = modes |> Enum.at(0, 0)
    op_2_mode = modes |> Enum.at(1, 0)

    op_1 = if op_1_mode == 1, do: pos_1, else: Enum.at(program, pos_1)
    op_2 = if op_2_mode == 1, do: pos_2, else: Enum.at(program, pos_2)

    program |> List.replace_at(pos_out, operation.(op_1, op_2))
  end

  @doc """
    Get a value from STDIN and store it.
  """
  def set_value(program, offset: offset) do
    position = Enum.at(program, offset + 1)

    input = IO.gets("i> ")
      |> String.trim
      |> String.to_integer

    program |> List.replace_at(position, input)
  end

  @doc """
    Retrieve a value and print it.
  """
  def get_value(program, offset: offset) do
    modes = program
      |> Enum.at(offset)
      |> get_modes

    position = Enum.at(program, offset + 1)
    param_mode = modes |> Enum.at(0, 0)

    if param_mode == 1, do: position, else: Enum.at(program, position)
    |> IO.puts

    program
  end

  @doc """
    Run the program at `offset`.
    Recurse with the offset increased by the number of params.
    If the operator is 99, just return the first item.
  """
  def run_program(program, offset: offset) do
    op = program
      |> Enum.at(offset)
      |> get_opcode

    case op do
      1 -> run_operation(program, offset: offset, operation: &Kernel.+/2)
            |> run_program(offset: offset + 4)
      2 -> run_operation(program, offset: offset, operation: &Kernel.*/2)
            |> run_program(offset: offset + 4)
      3 -> set_value(program, offset: offset)
            |> run_program(offset: offset + 2)
      4 -> get_value(program, offset: offset)
            |> run_program(offset: offset + 2)
      99 -> program |> List.first
    end
  end

  @doc """
    1. Read the file
    2. Trim out newlines
    3. Split on commas
    4. Convert items to integers
    5. Run the program.
  """
  def compute do
    File.read!("input.txt")
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> run_program(offset: 0)
  end
end


# Not printing the return value since the program has an output operator.
Day5.Part1.compute
