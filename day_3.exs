defmodule Day3Exercise1 do
  def overlap(input) do
    input |> Enum.flat_map(&claimed_coordinates/1) |> overlap_count
  end

  def claimed_coordinates(s) do
    [position_string] = Regex.run(~r{\d+,\d+}, s)
    [size_string] = Regex.run(~r{\d+x\d+}, s)

    [init_x, init_y] = Enum.map(String.split(position_string, ","), &String.to_integer(&1))
    [width, height] = Enum.map(String.split(size_string, "x"), &String.to_integer(&1))

    max_x = init_x + width - 1
    max_y = init_y + height - 1

    arr = for y <- init_y..max_y, x <- init_x..max_x, do: {x, y}
    arr
  end

  defp overlap_count(claims) do
    claims
    |> Enum.reduce(%{}, fn el, acc -> Map.put(acc, el, Map.get(acc, el, 0) + 1) end)
    |> Enum.filter(fn {_key, val} -> val != 1 end)
    |> length
  end
end

defmodule Day3Exercise2 do
  defmodule Claim do
    defstruct id: "", coords: []
  end

  def distinct_claim(input) do
    claims = input |> Enum.map(&build_claim/1)
    all_coords = Enum.flat_map(claims, fn claim -> claim.coords end)

    overlapping_coords =
      all_coords
      |> Enum.reduce(%{}, fn el, acc -> Map.put(acc, el, Map.get(acc, el, 0) + 1) end)
      |> Enum.flat_map(fn {coord, count} ->
        if count > 1 do
          [coord]
        else
          []
        end
      end)

    non_overlapping_claim(claims, overlapping_coords)
  end

  defp non_overlapping_claim([head | tail], overlapping_coords) do
    if Enum.any?(head.coords, fn coord -> coord in overlapping_coords end) do
      non_overlapping_claim(tail, overlapping_coords)
    else
      head.id
    end
  end

  defp build_claim(s) do
    [id] = Regex.run(~r{#\d+}, s)
    %Claim{id: id, coords: Day3Exercise1.claimed_coordinates(s)}
  end
end

ExUnit.start()
# ExUnit.start(timeout: 3_600_000)

defmodule Day3Exercise1Test do
  use ExUnit.Case

  import Day3Exercise1

  test "simple" do
    simple_input = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert overlap(simple_input) == 4
  end

  test "with input" do
    assert File.read!("input_3.txt") |> String.split("\n", trim: true) |> overlap == 118_223
  end
end

defmodule Day3Exercise2Test do
  use ExUnit.Case

  import Day3Exercise2

  test "simple" do
    simple_input = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    assert distinct_claim(simple_input) == "#3"
  end

  test "with input" do
    # this takes ~36s to run
    # assert File.read!("input_3.txt") |> String.split("\n", trim: true) |> distinct_claim == "#412"
  end
end
