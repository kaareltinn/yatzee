defmodule Yatzee.Engine do

  alias Yatzee.{Rules, Scorecard, State}

  def new_game() do
    %{
      players: %{},
      dices: Dices.new(),
      state: :initializing
    }
  end
  def new_game(players) do
    %{
      players: Enum.with_index(players) |> Enum.reduce(%{}, fn ({player, tag}, acc) ->
        Map.put(acc, tag, new_player_state(player, tag))
      end),
      dices: Dices.new(),
      state: :waiting_for_players
    }
  end

  def add_player(game, name) do
    new_player = new_player_state(game, name)
    players = Map.put(game.players, new_player.player_tag, new_player)
    %{ game | players: players}
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

  defp new_player_state(%{} = game, name) do
    players_count = Enum.count(game.players)

    %{
      name: name,
      scorecard: %Yatzee.Scorecard{},
      turns_left: 13,
      player_tag: players_count
    }
  end

  defp new_player_state(name, tag) do
    %{
      name: name,
      scorecard: %Yatzee.Scorecard{},
      turns_left: 13,
      player_tag: tag
    }
  end

  defp set_category(game, player_name, category, value) do
    section_key = Scorecard.get_section_key(category)

    put_in(
      game,
      [
        :players,
        player_name,
        :scorecard,
        Access.key(section_key),
        Access.key(category)
      ],
      value
    )
  end

  defp already_set?(game, player_tag, category) do
    section_key = Scorecard.get_section_key(category)
    case get_in(game, [:players, player_tag, :scorecard, Access.key(section_key), Access.key(category)]) do
      0 -> :ok
      _ -> :already_set
    end
  end
end
