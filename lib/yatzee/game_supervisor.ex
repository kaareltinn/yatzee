defmodule Yatzee.GameSupervisor do
  use DynamicSupervisor

  alias Yatzee.Game

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(game_name) do
    child_spec = %{
      id: Game,
      start: {Game, :start_link, [game_name]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_game(game_name) do
    :ets.delete(:games_table, game_name)
    child_pid = Game.game_pid(game_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
