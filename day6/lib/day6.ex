defmodule Day6 do
  def part_1(input) do
    input_points =
      input
      |> Enum.map(fn s ->
        [x, y] = String.split(s, ", ")
        %{x: String.to_integer(x), y: String.to_integer(y)}
      end)

    {mapped_input, _} =
      input_points
      |> Enum.map_reduce(1, fn point, acc ->
        {%{x: point.x, y: point.y, id: acc}, acc + 1}
      end)

    max_x = Enum.max_by(mapped_input, fn coord -> coord.x end).x
    min_x = Enum.min_by(mapped_input, fn coord -> coord.x end).x
    max_y = Enum.max_by(mapped_input, fn coord -> coord.y end).y
    min_y = Enum.min_by(mapped_input, fn coord -> coord.y end).y

    grid =
      for y <- min_y..max_y,
          x <- min_x..max_x,
          do: %{x: x, y: y, nearest: []}

    {_, distance_filled_grid} =
      mapped_input
      |> Enum.map_reduce(grid, fn input_point, grid_acc ->
        checked_grid =
          grid_acc
          |> Enum.map(fn grid_point ->
            mh_distance = manhattan_distance(input_point, grid_point)

            %{
              x: grid_point.x,
              y: grid_point.y,
              nearest: check_mh_distance(grid_point, mh_distance, input_point.id)
            }
          end)

        {input_point, checked_grid}
      end)

    infinite_area_ids =
      distance_filled_grid
      |> Enum.filter(fn grid_point ->
        grid_point.x == min_x || grid_point.x == max_x || grid_point.y == min_y ||
          grid_point.y == max_y
      end)
      |> Enum.map(fn grid_point ->
        if length(grid_point.nearest) > 1 do
          nil
        else
          %{nearest: [%{nearest_id: nearest_id}]} = grid_point
          nearest_id
        end
      end)
      |> Enum.uniq()
      |> Enum.reject(&(&1 == nil))

    bounded_grid_with_distances =
      distance_filled_grid
      |> Enum.reject(fn grid_point ->
        if length(grid_point.nearest) > 1 do
          true
        else
          %{nearest: [%{nearest_id: nearest_id}]} = grid_point
          nearest_id in infinite_area_ids
        end
      end)

    bounded_grid_with_distances
    |> Enum.reduce(%{}, fn grid_point, acc ->
      %{nearest: [%{nearest_id: nearest_id}]} = grid_point
      Map.put(acc, nearest_id, Map.get(acc, nearest_id, 0) + 1)
    end)
    |> Map.to_list()
    |> Enum.map(fn {_key, val} -> val end)
    |> Enum.max()
  end

  def part_2(input, limit) do
    input_points =
      input
      |> Enum.map(fn s ->
        [x, y] = String.split(s, ", ")
        %{x: String.to_integer(x), y: String.to_integer(y)}
      end)

    {mapped_input, _} =
      input_points
      |> Enum.map_reduce(1, fn point, acc ->
        {%{x: point.x, y: point.y, id: acc}, acc + 1}
      end)

    max_x = Enum.max_by(mapped_input, fn coord -> coord.x end).x
    min_x = Enum.min_by(mapped_input, fn coord -> coord.x end).x
    max_y = Enum.max_by(mapped_input, fn coord -> coord.y end).y
    min_y = Enum.min_by(mapped_input, fn coord -> coord.y end).y

    grid =
      for y <- min_y..max_y,
          x <- min_x..max_x,
          do: %{x: x, y: y, total_mh: 0}

    {_, distance_filled_grid} =
      mapped_input
      |> Enum.map_reduce(grid, fn input_point, grid_acc ->
        checked_grid =
          grid_acc
          |> Enum.map(fn grid_point ->
            mh_distance = manhattan_distance(input_point, grid_point)
            %{x: grid_point.x, y: grid_point.y, total_mh: grid_point.total_mh + mh_distance}
          end)

        {input_point, checked_grid}
      end)

    distance_filled_grid
    |> Enum.filter(fn grid_point ->
      grid_point.total_mh < limit
    end)
    |> length
  end

  defp manhattan_distance(point_one, point_two) do
    abs(point_one.x - point_two.x) + abs(point_one.y - point_two.y)
  end

  defp check_mh_distance(%{nearest: []}, mh_distance, input_id) do
    [%{nearest_id: input_id, distance: mh_distance}]
  end

  defp check_mh_distance(%{nearest: [head | tail]}, mh_distance, input_id) do
    if mh_distance == head.distance do
      [%{nearest_id: input_id, distance: mh_distance} | [head | tail]]
    else
      if mh_distance < head.distance do
        [%{nearest_id: input_id, distance: mh_distance}]
      else
        [head | tail]
      end
    end
  end

  defp sum_mh_distance(%{total_mh: total}, mh_distance, input_id) do
    total + mh_distance
  end

  defp sum_mh_distance(%{nearest: [head | tail]}, mh_distance, input_id) do
    if mh_distance == head.distance do
      [%{nearest_id: input_id, distance: mh_distance} | [head | tail]]
    else
      if mh_distance < head.distance do
        [%{nearest_id: input_id, distance: mh_distance}]
      else
        [head | tail]
      end
    end
  end
end
