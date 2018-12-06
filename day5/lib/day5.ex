defmodule Day5 do
  def part_1(input) do
    [first | rest] = String.to_charlist(input)
    react(rest, [], length(rest) + 1, first)
  end

  def part_2(input) do
    input_chars = String.to_charlist(input)

    # could filter and only remove characters that are present but it doesn't make a difference for small inputs really
    # the full input contains all characters anyway
    # unique_input_chars = Enum.uniq(input_chars)

    97..122
    # |> Enum.filter(fn x ->
    #   x in unique_input_chars
    # end)
    |> Enum.map(fn codepoint ->
      # remove codepoints from input list
      [first | rest] =
        Enum.reject(input_chars, fn char ->
          char == codepoint || char == codepoint - 32
        end)

      react(rest, [], length(rest) + 1, first)
    end)
    |> Enum.min()
  end

  defp react([], saved, last_length, comparer) when comparer == nil do
    remaining = Enum.reverse(saved)
    handle_remaining(remaining, last_length)
  end

  defp react([], saved, last_length, comparer) do
    remaining = Enum.reverse([comparer | saved])
    handle_remaining(remaining, last_length)
  end

  defp react([head | tail], saved, last_length, comparer) do
    diff = comparer - head

    if diff == 32 || diff == -32 do
      if tail == [] do
        react([], saved, last_length, nil)
      else
        [h | t] = tail
        react(t, saved, last_length, h)
      end
    else
      react(tail, [comparer | saved], last_length, head)
    end
  end

  defp handle_remaining(remaining, last_length) do
    rem_length = length(remaining)

    if rem_length == 0 || rem_length == last_length do
      rem_length
    else
      [first | rest] = remaining
      react(rest, [], rem_length, first)
    end
  end
end
