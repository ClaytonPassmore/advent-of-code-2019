require IntcodeComputer

defmodule Day7.Part2 do
  def find_max_thruster_signal(program) do
    permutations(5..9 |> Enum.to_list)
    |> Enum.reduce(0, fn perm, acc -> max(run_permutation(perm, program), acc) end)
  end

  def run_permutation(permutation, program) do
    pids = start_amplifiers(permutation, program)
    run_sequence(0, pids)
  end

  def start_amplifiers(permutation, program) do
    parent = self()

    for phase <- permutation do
      pid = spawn_link(fn -> IntcodeComputer.run_program(program, offset: 0, parent: parent) end)
      send(pid, { :input, phase })
      pid
    end
  end

  def run_sequence(input, pids) do
    dead = Enum.reduce(pids, false, fn pid, dead -> dead || !Process.alive?(pid) end)

    case dead do
      true -> input
      false -> Enum.reduce(pids, input, fn pid, input -> get_signal(pid, input) end)
        |> run_sequence(pids)
    end
  end

  def get_signal(pid, input) do
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
    2. Split on commas
    3. Trim out newlines
    4. Convert items to integers
    5. Find the max thruster signal.
  """
  def compute do
    File.read!("input.txt")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> find_max_thruster_signal
  end
end


Day7.Part2.compute |> IO.inspect
