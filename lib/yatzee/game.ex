defmodule Yatzee.Game do
  use GenServer

  # CLIENT

  @doc """
  Creates new game
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
  Adds new player to the game

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def add_player(game, player_name) do
    GenServer.call(game, {:add_player, player_name})
  end

  @doc """
  Starts the game

  Change game state from :waiting_for_players -> {:throwing_1, player_name}

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def start_game(game) do
    GenServer.call(game, :start_game)
  end

  @doc """
  Throws the dices

  Accepts names of the dices which will be thrown again

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def throw(game, dice_names) do
    GenServer.call(game, {:throw, dice_names})
  end

  @doc """
  Sets currently choosing players corresponding category field on scorecard

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :already_set
  - :no_match
  - :invalid_action
  """
  def choose(game, category) do
    GenServer.call(game, {:choose, category})
  end

  # CALLBACKS
  def init(:ok) do
    {:ok, init_state()}
  end

  def handle_call({:add_player, player_name}, _from, game_state) do
    {result, new_game_state} = Yatzee.add_player(game_state, player_name)
    {:reply, {result, new_game_state}, new_game_state}
  end

  def handle_call(:start_game, _from, game_state) do
    {result, new_game_state} = Yatzee.start_game(game_state)
    {:reply, {result, new_game_state}, new_game_state}
  end

  def handle_call({:throw, dice_names}, _from, game_state) do
    new_game_state = Yatzee.throw(game_state, dice_names)
    {:reply, new_game_state.dices, new_game_state }
  end

  def handle_call({:choose, category}, _from, game_state) do
    {result, new_game_state} = Yatzee.choose(game_state, category)
    {:reply, {result, new_game_state}, new_game_state}
  end

  defp init_state(), do: Yatzee.new_game()
end
