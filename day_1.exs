defmodule Exercise1 do
  def frequency(input) do
    Enum.reduce(input, 0, fn x, acc -> String.to_integer(x) + acc end)
  end
end

defmodule Exercise2 do
  def duplicate_frequency(input) do
    # find_freq(input, input, [0], 0)
    # find_freq(input, [0], 0)
    find_freq(input, MapSet.new([0]), 0)
  end

  # Tried without passing the original list around and just adding tested transforms to the end of the list
  # Was much faster than the original solution but the speed gain all came from prepending discovered frequencies instead of concatenating
  # This method is a little slower than passing original list around, because it does a lot of list concatenation
  # defp find_freq([head | tail], frequencies, last_frequency) do
  #   new_freq = last_frequency + String.to_integer(head)
  #
  #   if Enum.member?(frequencies, new_freq) do
  #     new_freq
  #   else
  #     find_freq(tail ++ [head], [new_freq | frequencies], new_freq)
  #   end
  # end

  # Using MapSet is much much quicker
  defp find_freq([head | tail], frequencies, last_frequency) do
    new_freq = last_frequency + String.to_integer(head)

    if new_freq in frequencies do
      new_freq
    else
      find_freq(tail ++ [head], MapSet.put(frequencies, new_freq), new_freq)
    end
  end

  # defp find_freq([], original_input, frequencies, last_frequency) do
  #   find_freq(original_input, original_input, frequencies, last_frequency)
  # end
  #
  # defp find_freq([head | tail], original_input, frequencies, last_frequency) do
  #   change = String.to_integer(head)
  #   new_freq = last_frequency + change
  #
  #   if Enum.member?(frequencies, new_freq) do
  #     new_freq
  #   else
  #     # changing this line from concatenating list to prepending dropped execution time from 60s to 16s
  #     # It doesn't matter what order the discovered frequencies are in so prepending is fine
  #     # find_freq(tail, original_input, frequencies ++ [new_freq], new_freq)
  #
  #     find_freq(tail, original_input, [new_freq | frequencies], new_freq)
  #   end
  # end
end

ExUnit.start()
# ExUnit.start(timeout: 3_600_000)

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
    assert File.read!("input_1.txt") |> String.split() |> duplicate_frequency == 137_041
  end
end
