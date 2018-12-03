defmodule Day2Exercise1 do
  def checksum(input) do
    twos = length_count(input, 2)
    threes = length_count(input, 3)
    twos * threes
  end

  defp length_count(input, length) do
    input
    |> Stream.map(fn s ->
      s
      |> String.graphemes()
      |> Enum.sort()
      |> Enum.chunk_by(& &1)
      |> Enum.any?(&(length(&1) == length))
    end)
    |> Enum.count(&(&1 == true))
  end
end

defmodule Day2Exercise2 do
  def common_letters(input) do
    [head | tail] = input
    find_matches(tail, input, head)
  end

  defp find_matches([], original_input, checking) do
    index = Enum.find_index(original_input, &(&1 == checking))
    {_, [to_check | tail]} = Enum.split(original_input, index + 1)
    find_matches(tail, original_input, to_check)
  end

  defp find_matches([head | tail], original_input, checking) do
    if dif_count(head, checking) == 1 do
      diffed_string(head, checking)
    else
      find_matches(tail, original_input, checking)
    end
  end

  defp dif_count(one, two) do
    Enum.zip(String.graphemes(one), String.graphemes(two))
    |> Enum.count(fn {a, b} -> a != b end)
  end

  defp diffed_string(one, two) do
    Enum.zip(String.graphemes(one), String.graphemes(two))
    |> Enum.reject(fn {a, b} -> a != b end)
    |> Enum.map(fn {a, _} -> a end)
    |> Enum.join()
  end
end

ExUnit.start()

defmodule Day2Exercise1Test do
  use ExUnit.Case

  import Day2Exercise1

  test "simple" do
    simple_input = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
    assert checksum(simple_input) == 12
  end

  test "with input" do
    assert File.read!("input_2.txt") |> String.split() |> checksum == 7808
  end
end

defmodule Day2Exercise2Test do
  use ExUnit.Case

  import Day2Exercise2

  test "simple" do
    simple_input = ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]
    assert common_letters(simple_input) == "fgij"
  end

  test "with input" do
    assert File.read!("input_2.txt") |> String.split() |> common_letters ==
             "efmyhuckqldtwjyvisipargno"
  end
end
