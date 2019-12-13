defmodule Day8.Part2 do
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

  def fetch_pixel(layer, h, w) do
    layer
    |> Enum.at(h)
    |> Enum.at(w)
  end

  def build_image(layers) do
    for h <- 0..(@image_height - 1) do
      for w <- 0..(@image_width - 1) do
        px = Enum.map(layers, fn layer -> fetch_pixel(layer, h, w) end)
          |> Enum.find(fn px -> px < 2 end)

        if px == 0, do: "⬛️", else: "⬜️"
      end
    end
  end

  def compute do
    File.read!("input.txt")
      |> String.trim
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> build_image_layers
      |> build_image
      |> Enum.map(&List.to_string/1)
      |> Enum.reduce(fn row, acc -> acc <> "\n" <> row end)
  end
end


Day8.Part2.compute |> IO.puts
