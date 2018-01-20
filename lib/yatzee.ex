defmodule Yatzee do
  defdelegate new_game(), to: Yatzee.Engine
  defdelegate throw(num), to: Dices
end
