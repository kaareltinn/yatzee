defmodule Yatzee do
  defdelegate new_game(),                           to: Yatzee.Engine
  defdelegate new_game(players),                    to: Yatzee.Engine
  defdelegate add_player(game, player_name),        to: Yatzee.Engine
  defdelegate start_game(game),                     to: Yatzee.Engine
  defdelegate throw(game, dice_names),              to: Yatzee.Engine
  defdelegate choose(game, category),               to: Yatzee.Engine
end
