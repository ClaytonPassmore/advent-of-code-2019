defmodule IntcodeComputer do
  # Split an opcode from parameter modes (if present).
  defp get_opcode(op) do
    op_list = op
      |> Integer.to_string
      |> String.codepoints

    # If the op_list contains positional info, slice that off to get the opcode.
    cond do
      (Enum.count(op_list) > 2) -> op_list |> Enum.slice(-2..-1) |> List.to_string |> String.to_integer
      true -> op
    end
  end

  # Return a list of parameter modes.
  # List may not alway match the number of parameters so Enum.at should be used
  # on this list with a default value of 0 to represent the default mode.
  defp get_modes(op) do
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

  # Handy helper for getting params that support both param modes.
  defp get_params(program, offset, count) do
    modes = program |> Enum.at(offset) |> get_modes

    for i <- 0..(count - 1) do
      position = program |> Enum.at(offset + 1 + i)
      mode = modes |> Enum.at(i, 0)

      if mode == 1, do: position, else: Enum.at(program, position)
    end
  end

  # Run the operation for the program at the given offset.
  defp run_operation(program, offset: offset, operation: operation) do
    [ op_1, op_2 ] = program |> get_params(offset, 2)

    position = program |> Enum.at(offset + 3)

    program |> List.replace_at(position, operation.(op_1, op_2))
  end

  # Get a value from STDIN and store it.
  defp set_value(program, offset: offset) do
    position = Enum.at(program, offset + 1)

    receive do
       { :input, value } -> program |> List.replace_at(position, value)
    end
  end

  # Retrieve a value and print it.
  defp get_value(program, offset: offset, parent: parent) do
    [ value ] = program |> get_params(offset, 1)

    send(parent, { :output, value } )

    program
  end

  # Returns an offset which is a jump if the condition is non-zero
  defp jump_if_true(program, offset: offset) do
    [ param_1, param_2 ] = program |> get_params(offset, 2)

    if param_1 == 0, do: offset + 3, else: param_2
  end

  # Returns an offset which is a jump if the condition is zero
  defp jump_if_false(program, offset: offset) do
    [ param_1, param_2 ] = program |> get_params(offset, 2)

    if param_1 == 0, do: param_2, else: offset + 3
  end

  # Compares two numbers and stores the result of the comparison
  defp less_than(program, offset: offset) do
    [ param_1, param_2 ] = program |> get_params(offset, 2)

    position = program |> Enum.at(offset + 3)
    value = if param_1 < param_2, do: 1, else: 0

    program |> List.replace_at(position, value)
  end

  # Compares two numbers and stores the result of the comparison
  defp equals(program, offset: offset) do
    [ param_1, param_2 ] = program |> get_params(offset, 2)

    position = program |> Enum.at(offset + 3)
    value = if param_1 == param_2, do: 1, else: 0

    program |> List.replace_at(position, value)
  end

  @doc """
    Run the program at `offset`.
    Recurse with the offset increased by the number of params.
    If the operator is 99, just return the first item.
  """
  def run_program(program, offset: offset, parent: parent) do
    op = program
      |> Enum.at(offset)
      |> get_opcode

    case op do
      1 -> run_operation(program, offset: offset, operation: &Kernel.+/2)
            |> run_program(offset: offset + 4, parent: parent)
      2 -> run_operation(program, offset: offset, operation: &Kernel.*/2)
            |> run_program(offset: offset + 4, parent: parent)
      3 -> set_value(program, offset: offset)
            |> run_program(offset: offset + 2, parent: parent)
      4 -> get_value(program, offset: offset, parent: parent)
            |> run_program(offset: offset + 2, parent: parent)
      5 -> new_offset = jump_if_true(program, offset: offset); run_program(program, offset: new_offset, parent: parent)
      6 -> new_offset = jump_if_false(program, offset: offset); run_program(program, offset: new_offset, parent: parent)
      7 -> less_than(program, offset: offset)
            |> run_program(offset: offset + 4, parent: parent)
      8 -> equals(program, offset: offset)
            |> run_program(offset: offset + 4, parent: parent)
      99 -> program |> List.first
    end
  end
end
