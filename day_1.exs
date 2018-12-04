defmodule Exercise1 do
  def frequency(input) do
    Enum.reduce(input, 0, fn x, acc -> String.to_integer(x) + acc end)
  end
end

defmodule Exercise2 do
  def duplicate_frequency(input) do
    find_freq(input, input, [0], 0)
  end

  defp find_freq([], original_input, frequencies, last_frequency) do
    find_freq(original_input, original_input, frequencies, last_frequency)
  end

  defp find_freq([head | tail], original_input, frequencies, last_frequency) do
    change = String.to_integer(head)
    new_freq = last_frequency + change

    if Enum.member?(frequencies, new_freq) do
      new_freq
    else
      find_freq(tail, original_input, frequencies ++ [new_freq], new_freq)
    end
  end
end

ExUnit.start()

defmodule Exercise1Test do
  use ExUnit.Case

  import Exercise1

  test "simple" do
    assert frequency(["+1", "+1", "+1"]) == 3
    assert frequency(["+1", "+1", "-2"]) == 0
    assert frequency(["-1", "-2", "-3"]) == -6
  end

  test "with input" do
    assert File.read!("input_1.txt") |> String.split() |> frequency == 474
  end
end

defmodule Exercise2Test do
  use ExUnit.Case

  import Exercise2

  test "simple" do
    assert duplicate_frequency(["-1", "+1"]) == 0
    assert duplicate_frequency(["+3", "+3", "+4", "-2", "-4"]) == 10
    assert duplicate_frequency(["-6", "+3", "+8", "+5", "-6"]) == 5
    assert duplicate_frequency(["+7", "+7", "-2", "-7", "-4"]) == 14
  end

  test "with input" do
    # This takes a while to run!
    # assert File.read!("input_1.txt") |> String.split() |> duplicate_frequency == 137_041
  end
end
