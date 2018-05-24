defmodule Yatzee.Engine do

  alias Yatzee.{Rules, Scorecard, States}

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
    with {:ok, %{state: :waiting_for_players} = game} <- States.check(:add_player, game)
    do
      new_player = new_player_state(game, name)
      players = Map.put(game.players, new_player.player_tag, new_player)
      %{ game | players: players}
    else
      {:invalid_action, game} -> {:invalid_action, game}
    end
  end

  def start_game(game) do
    States.check(:start_game, game)
  end

  def throw(game, dice_names) do
    case States.check(:throw, game) do
      {:ok, game} -> set_dices(game, dice_names)
      {:invalid_action, game} -> game
    end
  end

  def choose(game, category) do
    with %{state: {:choosing, %{player_tag: player_tag}}} <- game,
      {:ok, %{state: {:throwing_1, _}} = game} <- States.check(:choose, game),
      {:ok, ^category, value} <- Rules.check(game.dices, category),
      :ok <- already_set?(game, player_tag, category)
    do
      {:ok, set_category(game, player_tag, category, value)}
    else
      {:invalid_action, game} -> {:invalid_action, game}
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

  defp set_dices(game, dice_names) do
    dices = Map.merge(game.dices, Dices.throw(game.dices, dice_names))
    %{ game | dices: dices }
  end

  defp already_set?(game, player_tag, category) do
    section_key = Scorecard.get_section_key(category)
    case get_in(game, [:players, player_tag, :scorecard, Access.key(section_key), Access.key(category)]) do
      :not_set -> :ok
      _ -> :already_set
    end
  end
end
