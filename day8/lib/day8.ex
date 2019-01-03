defmodule Day8 do
  @type metadata :: non_neg_integer()
  @type tree_node :: {[tree_node], [metadata]}

  @moduledoc """
  Documentation for Day8.
  """

  def part_1(input) do
    input
    |> parse_input
    |> build_tree
    |> sum_metadata
  end

  def part_2(input) do
    input
    |> parse_input
    |> build_tree
    |> sum_child_metadata
  end

  @doc """
  Parse input

  ## Examples

      iex> Day8.parse_input("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
      [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]

  """
  def parse_input(input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Build tree

  ## Examples
      # iex> Day8.build_tree( [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2])
      # nil

      iex> Day8.build_tree( [0, 3, 1, 1, 2])
      {[], [1, 1, 2]}

      iex> Day8.build_tree( [1, 3, 0, 1, 99, 1, 1, 2])
      {
        [
          {[], [99]}
        ],
        [1, 1, 2]
      }

      iex> Day8.build_tree([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2])
      { # A
       [{ # B
         [],
         [10, 11, 12]
        },
        { # C
         [{ # D
           [],
           [99]
          }],
         [2]
        }],
       [1, 1, 2]
      }
  """

  def build_tree(integers) do
    {root, _rest} = build_node(integers)
    root
  end

  @doc """

  ## Examples
    iex> Day8.sum_metadata({ [{ [], [10, 11, 12] }, { [{ [], [99] }], [2] }], [1, 1, 2] })
    138
  """
  def sum_metadata(node, acc \\ 0)

  def sum_metadata({[], metadata}, acc) do
    acc + Enum.sum(metadata)
  end

  def sum_metadata({children, metadata}, acc) do
    acc = acc + Enum.sum(metadata)
    acc = acc + Enum.reduce(children, 0, &sum_metadata/2)
    acc
  end

  @doc """
      # { # A
      #  [{ # B
      #    [],
      #    [10, 11, 12]
      #   },
      #   { # C
      #    [{ # D
      #      [],
      #      [99]
      #     }],
      #    [2]
      #   }],
      #  [1, 1, 2]
      # }
  ## Examples
    iex> Day8.sum_child_metadata({ [], [10, 11, 12] })
    33

    iex> Day8.sum_child_metadata({ [{ [], [10, 11, 12] }, { [{ [], [99] }], [2] }], [1, 1, 2] })
    66


  """
  def sum_child_metadata({[], metadata}) do
    Enum.sum(metadata)
  end

  def sum_child_metadata({children, metadata}) do
    metadata
    |> Enum.map(fn x ->
      case Enum.split(children, x - 1) do
        {_before, []} -> 0
        {_before, [child | _after]} -> sum_child_metadata(child)
      end
    end)
    |> Enum.sum()
  end

  defp build_node([child_count, metadata_count | rest]) do
    {children, rest} = children(child_count, rest, [])
    {metadata, rest} = Enum.split(rest, metadata_count)
    {{children, metadata}, rest}
  end

  defp children(0, rest, acc) do
    {Enum.reverse(acc), rest}
  end

  defp children(count, rest, acc) do
    {node, rest} = build_node(rest)
    children(count - 1, rest, [node | acc])
  end
end
