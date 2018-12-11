defmodule Day6Test do
  use ExUnit.Case

  test "part_1 simple" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert input |> String.split("\n", trim: true) |> Day6.part_1() == 17
  end

  test "part_1 with file" do
    assert File.read!("input.txt") |> String.split("\n", trim: true) |> Day6.part_1() == 3933
  end

  test "part_2 simple" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert input |> String.split("\n", trim: true) |> Day6.part_2(32) == 16
  end

  test "part_2 with file" do
    assert File.read!("input.txt") |> String.split("\n", trim: true) |> Day6.part_2(10000) ==
             41145
  end
end
