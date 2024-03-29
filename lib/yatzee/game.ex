defmodule Yatzee.Game do
  use GenServer

  # CLIENT

  @doc """
  Creates new game
  """
  def start_link(game_name) do
    GenServer.start_link(__MODULE__, {:ok, game_name}, name: via_tuple(game_name))
  end

  @doc """
  Adds new player to the game

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def add_player(game_name, player_name) do
    GenServer.call(via_tuple(game_name), {:add_player, player_name})
  end

  @doc """
  Starts the game

  Change game state from :waiting_for_players -> {:throwing_1, player_name}

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def start_game(game_name) do
    GenServer.call(via_tuple(game_name), :start_game)
  end

  @doc """
  Throws the dices

  Accepts names of the dices which will be thrown again

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :invalid_action
  """
  def throw(game_name, dice_names) do
    GenServer.call(via_tuple(game_name), {:throw, dice_names})
  end

  @doc """
  Sets currently choosing players corresponding category field on scorecard

  Returns {result, new_game_state}, where result is one of following:
  - :ok
  - :already_set
  - :no_match
  - :invalid_action
  """
  def choose(game_name, category) do
    GenServer.call(via_tuple(game_name), {:choose, category})
  end

  @doc """
  Returns a tuple used to register and lookup a game server process by name.
  """
  def via_tuple(game_name) do
    {:via, Registry, {Yatzee.GameRegistry, game_name}}
  end

  @doc """
  Returns the `pid` of the game server process registered under the
  given `game_name`, or `nil` if no process is registered.
  """
  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  # CALLBACKS
  def init({:ok, game_name}) do
    {:ok, init_state(game_name)}
  end

  def handle_call({:add_player, player_name}, _from, game_state) do
    {result, new_game_state} = Yatzee.Engine.add_player(game_state, player_name)
    :ets.insert(:games_table, {my_game_name(), new_game_state})
    {:reply, {result, new_game_state}, new_game_state}
  end

  def handle_call(:start_game, _from, game_state) do
    {result, new_game_state} = Yatzee.Engine.start_game(game_state)
    :ets.insert(:games_table, {my_game_name(), new_game_state})
    {:reply, {result, new_game_state}, new_game_state}
  end

  def handle_call({:throw, dice_names}, _from, game_state) do
    {result, new_game_state} = Yatzee.Engine.throw(game_state, dice_names)
    :ets.insert(:games_table, {my_game_name(), new_game_state})
    {:reply, {result, new_game_state.dices}, new_game_state}
  end

  def handle_call({:choose, category}, _from, game_state) do
    {result, new_game_state} = Yatzee.Engine.choose(game_state, category)
    :ets.insert(:games_table, {my_game_name(), new_game_state})
    {:reply, {result, new_game_state}, new_game_state}
  end

  defp init_state(game_name) do
    case :ets.lookup(:games_table, game_name) do
      [] ->
        game = Yatzee.Engine.new_game()
        :ets.insert(:games_table, {game_name, game})
        game

      [{^game_name, game}] ->
        game
    end
  end

  defp my_game_name() do
    Registry.keys(Yatzee.GameRegistry, self()) |> List.first()
  end
end
