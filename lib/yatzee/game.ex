defmodule Yatzee.Game do
  use GenServer

  # CLIENT
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def add_player(game, player_name) do
    GenServer.call(game, {:add_player, player_name})
  end

  def start_game(game) do
    GenServer.call(game, :start_game)
  end

  def throw(game, dice_names) do
    GenServer.call(game, {:throw, dice_names})
  end

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
