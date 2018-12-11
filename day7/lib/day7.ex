defmodule Day7 do
  def part_1(input) do
    parsed_steps =
      input
      |> parse_input

    complete(parsed_steps)
  end

  def part_2(input, workers, delay) do
    parsed_steps =
      input
      |> parse_input

    work(parsed_steps, workers, delay)
  end

  defp work(steps, workers, delay, current_steps \\ [], current_second \\ 0)

  defp work(steps, workers, delay, current_steps, current_second)
       when current_steps == [] do
    first_step = Enum.find(steps, &(&1.prereqs == []))
    incomplete_steps = Enum.reject(steps, &(&1 == first_step))

    [codepoint] = to_charlist(first_step.step)
    time_to_process = codepoint - 64 + delay

    work(
      incomplete_steps,
      workers,
      delay,
      [
        %{step: first_step.step, complete_at: time_to_process + current_second}
      ],
      time_to_process + current_second
    )
  end

  defp work([], _workers, _delay, _current_steps, current_second) do
    current_second
  end

  defp work(steps, workers, delay, current_steps, current_second) do
    completed_step_ids =
      current_steps
      |> Enum.filter(&(&1.complete_at == current_second))
      |> Enum.map(& &1.step)

    in_progress_steps = Enum.reject(current_steps, &(&1.complete_at == current_second))

    processed_steps =
      steps
      |> Enum.map(fn %{prereqs: prereqs, step: step} ->
        %{
          prereqs: Enum.reject(prereqs, &(&1 in completed_step_ids)),
          step: step
        }
      end)

    available_worker_count = workers - length(in_progress_steps)
    # [next_step | _other_ready_steps] =
    next_steps =
      Enum.filter(processed_steps, &(&1.prereqs == []))
      |> Enum.sort_by(& &1.step)
      |> Enum.take(available_worker_count)

    next_processes =
      next_steps
      |> Enum.map(fn step ->
        [codepoint] = to_charlist(step.step)
        time_to_process = codepoint - 64 + delay

        %{step: step.step, complete_at: time_to_process + current_second}
      end)

    current_processes = next_processes ++ in_progress_steps
    next_event = Enum.min_by(current_processes, fn process -> process.complete_at end).complete_at

    incomplete_steps =
      Enum.reject(processed_steps, &(&1.step in Enum.map(current_processes, fn x -> x.step end)))

    work(incomplete_steps, workers, delay, current_processes, next_event)
  end

  defp complete(steps, completed \\ [], current_step \\ nil)

  defp complete([], completed, current_step) do
    Enum.join(Enum.reverse([current_step | completed]))
  end

  defp complete(steps, completed, current_step) when current_step == nil do
    first_step = Enum.find(steps, &(&1.prereqs == []))

    incomplete_steps = Enum.reject(steps, &(&1 == first_step))

    complete(incomplete_steps, completed, first_step.step)
  end

  defp complete(steps, completed, current_step) do
    processed_steps =
      steps
      |> Enum.map(fn %{prereqs: prereqs, step: step} ->
        %{
          prereqs: Enum.reject(prereqs, &(&1 == current_step)),
          step: step
        }
      end)

    [next_step | _other_ready_steps] =
      Enum.filter(processed_steps, &(&1.prereqs == []))
      |> Enum.sort_by(& &1.step)

    incomplete_steps = Enum.reject(processed_steps, &(&1 == next_step))
    complete(incomplete_steps, [current_step | completed], next_step.step)
  end

  defp parse_input(input) do
    parsed_input =
      input
      |> Enum.map(fn s ->
        [prereq, step] =
          String.split(s, ["Step ", " must be finished before step ", " can begin."], trim: true)

        %{prereq: prereq, step: step}
      end)

    prereqs =
      parsed_input
      |> Enum.reduce(%{}, fn step_input, acc ->
        Map.put(acc, step_input.prereq, [])
      end)

    parsed_input
    |> Enum.reduce(prereqs, fn step_input, acc ->
      Map.put(acc, step_input.step, [step_input.prereq | Map.get(acc, step_input.step, [])])
    end)
    |> Enum.map(fn {step, prereqs} ->
      %{step: step, prereqs: prereqs}
    end)
  end
end
