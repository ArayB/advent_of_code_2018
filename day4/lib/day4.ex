defmodule Day4 do
  def part_1(input) do
    guard =
      input
      |> parse_input
      |> sort_parsed_input
      |> group_parsed_input
      |> calculate_asleep_minutes
      |> select_guard_by_most_minutes_asleep

    %{sum_asleep: _total, most_asleep_minute: most_asleep_minute, id: id} = guard

    String.to_integer(id) * most_asleep_minute
  end

  def part_2(input) do
    guard =
      input
      |> parse_input
      |> sort_parsed_input
      |> group_parsed_input
      |> calculate_asleep_minutes
      |> select_guard_by_most_frequent_on_same_minute

    %{count: _count, most_asleep_minute: most_asleep_minute, id: id} = guard
    String.to_integer(id) * most_asleep_minute
  end

  defp parse_input(input) do
    input
    |> Enum.map(fn line ->
      [date_part, instruction] = String.split(line, ["[", "] "], trim: true)
      {:ok, date_time} = NaiveDateTime.from_iso8601(date_part <> ":00")
      [date_time, instruction]
    end)
  end

  defp sort_parsed_input(parsed_input) do
    parsed_input
    |> Enum.sort(fn [left, _], [y, _] ->
      NaiveDateTime.compare(left, y) == :lt
    end)
  end

  defp group_parsed_input(sorted_input) do
    sorted_input
    |> Enum.chunk_by(fn [datetime, _instr] ->
      if datetime.hour == 23 do
        datetime.day + 1
      else
        datetime.day
      end
    end)
  end

  defp calculate_asleep_minutes(grouped_input) do
    grouped_input
    |> Enum.map(fn x -> asleep_for_group(x, []) end)
  end

  defp asleep_for_group(group, events, guard_id \\ nil)

  defp asleep_for_group([], events, guard_id) do
    asleep_minutes =
      Enum.chunk_every(events, 2)
      |> Enum.flat_map(&minutes_asleep/1)

    %{id: guard_id, total_asleep: Enum.sum(asleep_minutes), asleep_minutes: asleep_minutes}
  end

  defp asleep_for_group([head | tail], events, guard_id) do
    [date_time, instr] = head

    case instr do
      "wakes up" ->
        asleep_for_group(tail, [%{awake: date_time.minute} | events], guard_id)

      "falls asleep" ->
        asleep_for_group(tail, [%{asleep: date_time.minute} | events], guard_id)

      _ ->
        [_, id, _, _] = String.split(instr, [" ", " #"], trim: true)
        asleep_for_group(tail, events, id)
    end
  end

  defp minutes_asleep(event_chunk) do
    [%{awake: awk}, %{asleep: asl}] = event_chunk
    Enum.to_list(asl..(awk - 1))
  end

  defp select_guard_by_most_minutes_asleep(calculated_sleeps) do
    calculated_sleeps
    |> Enum.reject(fn %{total_asleep: total} -> total == 0 end)
    |> Enum.group_by(fn %{id: id} -> id end)
    |> Enum.map(fn {id, sleep_info} ->
      total = Enum.reduce(sleep_info, 0, fn %{total_asleep: el}, acc -> el + acc end)

      {most_asleep_minute, _} =
        Enum.flat_map(sleep_info, fn %{asleep_minutes: el} -> el end)
        |> Enum.reduce(%{}, fn el, acc ->
          Map.put(acc, el, Map.get(acc, el, 0) + 1)
        end)
        |> Enum.filter(fn {_key, val} -> val != 1 end)
        |> Enum.max_by(fn {_key, val} -> val end)

      %{sum_asleep: total, most_asleep_minute: most_asleep_minute, id: id}
    end)
    |> Enum.max_by(fn %{sum_asleep: x} -> x end)
  end

  defp select_guard_by_most_frequent_on_same_minute(calculated_sleeps) do
    calculated_sleeps
    |> Enum.reject(fn %{total_asleep: total} -> total == 0 end)
    |> Enum.group_by(fn %{id: id} -> id end)
    |> Enum.map(fn {id, sleep_info} ->
      {most_asleep_minute, count} =
        Enum.flat_map(sleep_info, fn %{asleep_minutes: el} -> el end)
        |> Enum.reduce(%{}, fn el, acc ->
          Map.put(acc, el, Map.get(acc, el, 0) + 1)
        end)
        |> Enum.filter(fn {_key, val} -> val != 1 end)
        |> Enum.max_by(fn {_key, val} -> val end)

      %{count: count, most_asleep_minute: most_asleep_minute, id: id}
    end)
    |> Enum.max_by(fn %{count: x} -> x end)
  end
end
