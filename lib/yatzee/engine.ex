defmodule Yatzee.Engine do
  def new_game() do
    %{
      scorecard: %Yatzee.Scorecard{},
      turns_left: 13
    }
  end
end
