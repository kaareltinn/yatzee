defmodule Yatzee do
  defdelegate new_game(players), to: Yatzee.Engine
  defdelegate throw(game, dice_names), to: Yatzee.Engine
  defdelegate choose(game, player_name, category), to: Yatzee.Engine
end
