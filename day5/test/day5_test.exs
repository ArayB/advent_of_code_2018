defmodule Day5Test do
  use ExUnit.Case

  test "part_1 aA" do
    input = """
    aA
    """

    assert input |> String.trim() |> Day5.part_1() == 0
  end

  test "part_1 abBA" do
    input = """
    abBA
    """

    assert input |> String.trim() |> Day5.part_1() == 0
  end

  test "part_1 simple" do
    input = """
    dabAcCaCBAcCcaDA
    """

    assert input |> String.trim() |> Day5.part_1() == 10
  end

  test "part_1 with file" do
    assert File.read!("input.txt") |> String.trim() |> Day5.part_1() == 11042
  end

  test "part_2 simple" do
    input = """
    dabAcCaCBAcCcaDA
    """

    assert input |> String.trim() |> Day5.part_2() == 4
  end

  test "part_2 with file" do
    assert File.read!("input.txt") |> String.trim() |> Day5.part_2() == 6872
  end
end
