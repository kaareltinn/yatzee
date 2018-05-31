defmodule Yatzee.Player do
  defstruct name: nil,
            scorecard: Yatzee.Scorecard.new(),
            player_tag: nil

  alias __MODULE__

  def new(name, player_tag) do
    %Player{name: name, player_tag: player_tag}
  end
end
