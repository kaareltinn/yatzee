defmodule Yatzee do
  defdelegate new_game(game_name), to: Yatzee.GameSupervisor
  defdelegate add_player(game_name, player_name), to: Yatzee.Game
  defdelegate start_game(game_name), to: Yatzee.Game
  defdelegate throw(game_name, dices), to: Yatzee.Game
  defdelegate choose(game_name, category), to: Yatzee.Game
end
