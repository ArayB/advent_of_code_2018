defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "part_1 with file" do
    assert File.read!("input.txt")
           |> String.trim("\n")
           |> Day8.part_1() == 41849
  end

  test "part_2 simple" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    assert input |> Day8.part_2() == 66
  end

  test "part_2 with file" do
    assert File.read!("input.txt")
           |> String.trim("\n")
           |> Day8.part_2() == 32487
  end
end
