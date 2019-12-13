defmodule Day8.Part1 do
  @image_width 25
  @image_height 6

  def build_row(input, row \\ []) do
    count = Enum.count(row)

    cond do
      count == @image_width -> [ input, Enum.reverse(row) ]
      true -> [ head | tail ] = input; build_row(tail, [ head | row ])
    end
  end

  def build_layer(input, layer \\ []) do
    count = Enum.count(layer)

    cond do
      count == @image_height -> [ input, Enum.reverse(layer) ]
      true -> [ input, row ] = build_row(input); build_layer(input, [ row | layer ])
    end
  end

  def build_image_layers(input, layers \\ [])

  def build_image_layers([], layers), do: Enum.reverse(layers)

  def build_image_layers(input, layers) do
    [ leftover, layer ] = build_layer(input)

    build_image_layers(leftover, [ layer | layers ])
  end

  def num_digits_matching(layer, matcher) do
    Enum.reduce(layer, 0, fn row, sum -> sum + num_digits_matching_in_row(row, matcher) end)
  end

  def num_digits_matching_in_row(row, matcher) do
    Enum.reduce(row, 0, fn item, sum -> sum + if item == matcher, do: 1, else: 0 end)
  end

  def compute do
    layers = File.read!("input.txt")
      |> String.trim
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> build_image_layers

    layer = Enum.min_by(layers, fn layer -> num_digits_matching(layer, 0) end)

    num_ones = num_digits_matching(layer, 1)
    num_twos = num_digits_matching(layer, 2)

    num_ones * num_twos
  end
end


Day8.Part1.compute |> IO.inspect
