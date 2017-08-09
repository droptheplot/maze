defmodule Maze do
  @doc """
  ## Examples

      iex> Maze.solve([[:S, 0, 0], [1, 1, 0], [1, 1, :E]])
      [[:X, :X, :X], [1, 1, :X], [1, 1, :E]]

      iex> Maze.solve([[:S, 0, 1], [1, 0, 1], [1, 0, :E]])
      [[:X, :X, 1], [1, :X, 1], [1, :X, :E]]

      iex> Maze.solve([[:S, 1, 1], [0, 0, 1], [1, 0, :E]])
      [[:X, 1, 1], [:X, :X, 1], [1, :X, :E]]

      iex> Maze.solve([[:S, 1, 1], [0, 0, 1], [1, 0, :E]])
      [[:X, 1, 1], [:X, :X, 1], [1, :X, :E]]

      iex> Maze.solve([[:S, 0, 0], [1, 0, 1], [1, 0, :E]])
      [[:X, :X, 0], [1, :X, 1], [1, :X, :E]]

      iex> Maze.solve([[:S, 0, 0, 0], [1, 0, 1, 1], [1, 0, 0, :E]])
      [[:X, :X, 0, 0], [1, :X, 1, 1], [1, :X, :X, :E]]

      iex> Maze.solve([[:S, 1, 1], [0, 1, 1], [:E, 1, 1]])
      [[:X, 1, 1], [:X, 1, 1], [:E, 1, 1]]

      iex> Maze.solve([[:S, 1, :E], [0, 1, 0], [0, 0, 0]])
      [[:X, 1, :E], [:X, 1, :X], [:X, :X, :X]]

      iex> Maze.solve([[:S, 0, 0], [1, 0, 1], [:E, 0, 0]])
      [[:X, :X, 0], [1, :X, 1], [:E, :X, 0]]

  """
  def solve(maze) do
    solve(maze, [0, 0])
  end

  def solve(maze, current_pos) do
    case solved?(maze, current_pos) do
      true ->
        maze
      false ->
        new_maze = generate_new_maze(maze, current_pos)

        valid_moves(new_maze, current_pos)
        |> Enum.map(&solve(new_maze, &1))
        |> Enum.reject(&is_nil/1)
        |> Enum.at(0)
    end
  end

  @doc """
  ## Examples

      iex> Maze.solved?([[:S, :X, :X], [1, 1, :X], [1, 1, :E]], [2, 2])
      true

      iex> Maze.solved?([[:S, :X, :X], [1, 1, 0], [1, 1, :E]], [1, 2])
      false

  """
  def solved?(maze, [ph, pv]) do
    value =
      maze
      |> Enum.at(ph)
      |> Enum.at(pv)

    value == :E
  end

  @doc """
  ## Examples

      iex> Maze.generate_new_maze([[:S, 0, 0], [1, 1, 0], [1, 1, :E]], [0, 1])
      [[:S, :X, 0], [1, 1, 0], [1, 1, :E]]

  """
  def generate_new_maze(maze, [ph, pv]) do
    new_row =
      maze
      |> Enum.at(ph)
      |> List.replace_at(pv, :X)

    List.replace_at(maze, ph, new_row)
  end

  @doc """
  ## Examples

      iex> Maze.valid_moves([[:S, 0, 0], [1, 1, 0], [1, 1, :E]], [0, 0])
      [[0, 1]]

      iex> Maze.valid_moves([[:S, 0, 0], [1, 1, 0], [1, 1, :E]], [0, 1])
      [[0, 2]]

      iex> Maze.valid_moves([[:S, :X, 0], [1, 1, 0], [1, 1, :E]], [0, 2])
      [[1, 2]]

  """
  def valid_moves(maze, [ph, pv]) do
    all_moves([ph, pv])
    |> Enum.reject(fn([ph, pv]) -> move_outside?(maze, [ph, pv]) end)
    |> Enum.map(fn([ph, pv]) ->
      maze
      |> Enum.at(ph)
      |> Enum.at(pv)
      |> valid_cell?([ph, pv])
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp all_moves([ph, pv]) do
    [[ph - 1, pv],
    [ph, pv + 1],
    [ph + 1, pv],
    [ph, pv - 1]]
  end

  defp move_outside?(maze, [ph, pv]) do
    ph < 0 || pv < 0 || ph > max_h_pos(maze) || pv > max_v_pos(maze)
  end

  defp valid_cell?(:E, pos), do: pos
  defp valid_cell?(0,  pos), do: pos
  defp valid_cell?(_, _),    do: nil

  defp max_v_pos(maze), do: length(Enum.at(maze, 0)) - 1
  defp max_h_pos(maze), do: length(maze) - 1
end
