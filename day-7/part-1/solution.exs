require IntcodeComputer

defmodule Day7.Part1 do
  def find_max_thruster_signal(program) do
    permutations(0..4 |> Enum.to_list)
    |> Enum.reduce(0, fn perm, acc -> max(run_permutation(perm, program), acc) end)
  end

  def run_permutation(permutation, program) do
    permutation |>
    Enum.reduce(0, fn phase, input -> get_signal(program, phase, input) end)
  end

  def get_signal(program, phase, input) do
    parent = self()
    pid = spawn_link(fn -> IntcodeComputer.run_program(program, offset: 0, parent: parent) end)

    send(pid, { :input, phase })
    send(pid, { :input, input })

    receive do
      { :output, output } -> output
    end
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for head <- list, tail <- permutations(list -- [ head ]) do
      [ head | tail ]
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
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> find_max_thruster_signal
  end
end


Day7.Part1.compute |> IO.inspect
