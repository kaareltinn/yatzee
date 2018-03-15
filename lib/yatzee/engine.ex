defmodule Yatzee.Engine do

  alias Yatzee.{Rules, Scorecard}

  def new_game(players) do
    %{
      players: Enum.reduce(players, %{}, fn (name, acc) ->
        Map.put(acc, name, new_player_state(name))
      end),
      dices: Dices.new()
    }
  end

  def throw(game, dice_names) do
    dices = Map.merge(game.dices, Dices.throw(game.dices, dice_names))
    %{ game | dices: dices }
  end

  def choose(game, player_name, section, category) do
    case Rules.check(game.dices, category) do
      {:ok, ^category, value} -> {:ok, set_category(game, player_name, section, category, value)}
      {:no_match, category} -> {:error, game}
    end
  end

  defp new_player_state(player) do
    %{
      name: player,
      scorecard: %Yatzee.Scorecard{},
      turns_left: 13
    }
  end

  defp set_category(game, player_name, section, category, value) do
    update_in(
      game,
      [:players, player_name, :scorecard],
      &Scorecard.update(&1, section, category, value)
    )
  end
end
