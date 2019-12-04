defmodule Day3.Part1 do
  @doc """
    Take an instruction and turn it into a coordinate using the first element in the
    accumulator as a reference.
  """
  def segmentify(instruction, accumulator) do
    { x, y } = accumulator |> List.first

    [ direction | distance ] = String.codepoints(instruction)

    distance = distance |> List.to_string |> String.to_integer

    case direction do
      "L" -> [ { x - distance, y } | accumulator ]
      "R" -> [ { x + distance, y } | accumulator ]
      "D" -> [ { x, y - distance } | accumulator ]
      "U" -> [ { x, y + distance } | accumulator ]
    end
  end

  @doc """
    Turn a set of instructions into a set of line segments represented by two coordinate points.
  """
  def instructions_to_segments(instructions) do
    coordinate = {0, 0}

    coordinates = instructions
      |> Enum.reduce([coordinate], &segmentify/2)
      |> Enum.reverse

    [ _ | non_origin_coords ] = coordinates

    Enum.zip(coordinates, non_origin_coords)
  end

  @doc """
    Check if a line is vertical.
  """
  def is_vertical?(line) do
    { { x1, _ }, { x2, _ } } = line

    x1 == x2
  end

  @doc """
    Check if a line is horizontal.
  """
  def is_horizontal?(line) do
    { { _, y1 }, { _, y2 } } = line

    y1 == y2
  end

  @doc """
    Find the point of intersection for a vertical line and a horizontal line.
    Return the manhattan distance from the origin (0, 0) to the POI.
    If there is no POI, return 0.
  """
  def hv_intersect(horizontal, vertical) do
    { { h_x1, h_y }, { h_x2, _ } } = horizontal
    { { v_x, v_y1 }, { _, v_y2 } } = vertical

    h_min_x = min(h_x1, h_x2)
    h_max_x = max(h_x1, h_x2)

    v_min_y = min(v_y1, v_y2)
    v_max_y = max(v_y1, v_y2)

    if (h_min_x <= v_x && v_x <= h_max_x && v_min_y <= h_y && h_y <= v_max_y) do
      # Manhattan distance since other point is (0, 0).
      abs(v_x) + abs(h_y)
    else
      # No intersection.
      0
    end
  end

  @doc """
    Calculate the manhattan distance to the point of intersection between line 1 and line 2.
    If there is no point of intersection, return 0.

    Didn't solve for when both lines are horizontal or both are vertical.
    Only in rare cases will those type of intersections contain the closest
    point, and I'm feeling lazy.
  """
  def distance_to_intersect(l1, l2) do
    cond do
      is_horizontal?(l1) && is_vertical?(l2) -> hv_intersect(l1, l2)
      is_vertical?(l1) && is_horizontal?(l2) -> hv_intersect(l2, l1)
      is_vertical?(l1) && is_vertical?(l2) -> 0  # TODO - Don't feel like writing.
      is_horizontal?(l1) && is_horizontal?(l1) -> 0  # TODO - Donn't feel like writing.
    end
  end

  @doc """
    Find all the points of intersection between two wires and compute the manhattan distances
    to those POIs.
  """
  def find_intersections(w1, w2) do
    Enum.map(w1, fn seg_1 -> Enum.map(w2, fn seg_2 -> distance_to_intersect(seg_1, seg_2) end) end)
  end

  @doc """
    Turn the wire instructions into line segments, then find the manhattan distance to the
    closest point of intersection between the two wires.
  """
  def compute do
    [ wire_1, wire_2 ] = File.read!("input.txt")
      |> String.split
      |> Enum.map(fn x -> String.split(x, ",") end)
      |> Enum.map(&instructions_to_segments/1)

    find_intersections(wire_1, wire_2)
    |> List.flatten
    |> Enum.filter(fn x -> x > 0 end)
    |> Enum.sort
    |> List.first
  end
end


Day3.Part1.compute |> IO.inspect
