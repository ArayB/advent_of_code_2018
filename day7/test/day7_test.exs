defmodule Day7Test do
  use ExUnit.Case

  test "part_1 simple" do
    input = """
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """

    assert input |> String.split("\n", trim: true) |> Day7.part_1() == "CABDFE"
  end

  test "part_1 with file" do
    assert File.read!("input.txt") |> String.split("\n", trim: true) |> Day7.part_1() ==
             "BGKDMJCNEQRSTUZWHYLPAFIVXO"
  end

  test "part_2 simple" do
    input = """
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """

    workers = 2
    delay = 0
    assert input |> String.split("\n", trim: true) |> Day7.part_2(workers, delay) == 15
  end

  test "part_2 with file" do
    workers = 5
    delay = 60

    assert File.read!("input.txt")
           |> String.split("\n", trim: true)
           |> Day7.part_2(workers, delay) == 941
  end
end
