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

  def choose(game, player_name, category) do
    with {:ok, ^category, value} <- Rules.check(game.dices, category),
      :ok <- already_set?(game, player_name, category)
    do
      {:ok, set_category(game, player_name, category, value)}
    else
      :already_set -> {:already_set, game}
      {:no_match, ^category} -> {:no_match, game}
    end
  end

  defp new_player_state(player) do
    %{
      name: player,
      scorecard: %Yatzee.Scorecard{},
      turns_left: 13
    }
  end

  defp set_category(game, player_name, category, value) do
    update_in(
      game,
      [:players, player_name, :scorecard],
      &Scorecard.update(&1, category, value)
    )
  end

  defp already_set?(game, player_name, category) do
    section_key = Scorecard.get_section(category)
    case get_in(game, [:players, player_name, :scorecard, Access.key(section_key), Access.key(category)]) do
      0 -> :ok
      _ -> :already_set
    end
  end
end
