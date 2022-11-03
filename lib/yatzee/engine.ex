defmodule Yatzee.Engine do
  alias Yatzee.{Dices, Rules, Scorecard, States, Player}

  def new_game() do
    %{
      players: %{},
      dices: Dices.new(),
      state: :initializing,
      players_turns: []
    }
  end

  def new_game(players) do
    %{
      players: initialize_players(players),
      dices: Dices.new(),
      state: :waiting_for_players,
      players_turns: []
    }
  end

  def add_player(game, name) do
    with {:ok, %{state: :waiting_for_players} = game} <- States.check(:add_player, game) do
      {:ok,
       %{game | players: Map.put(game.players, name, Player.new(name, Enum.count(game.players)))}}
    else
      {:invalid_action, game} -> {:invalid_action, game}
    end
  end

  def start_game(game) do
    States.check(:start_game, game)
  end

  def throw(game, dice_names) do
    case States.check(:throw, game) do
      {:ok, game} -> {:ok, set_dices(game, dice_names)}
      {:invalid_action, game} -> {:invalid_action, game}
    end
  end

  def choose(%{state: {:choosing, player_name}} = game, category) do
    with {:ok, %{state: {:throwing_1, _}} = game} <- States.check(:choose, game),
         {:ok, ^category, value} <- Rules.check(game.dices, category),
         :ok <- already_set?(game, player_name, category) do
      {:ok, set_category(game, player_name, category, value)}
    else
      {:invalid_action, game} -> {:invalid_action, game}
      :already_set -> {:already_set, game}
      {:no_match, ^category} -> {:no_match, game}
    end
  end

  def choose(game, _), do: {:invalid_action, game}

  defp initialize_players(players) do
    players
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {name, player_tag}, acc ->
      Map.put(acc, name, Player.new(name, player_tag))
    end)
  end

  defp set_category(game, player_name, category, value) do
    section_key = Scorecard.get_section_key(category)

    put_in(
      game,
      get_player_scoreboard_path(player_name, section_key, category),
      value
    )
  end

  defp set_dices(game, dice_names) do
    %{game | dices: Dices.throw(game.dices, dice_names)}
  end

  defp already_set?(game, player_name, category) do
    section_key = Scorecard.get_section_key(category)

    case get_in(game, get_player_scoreboard_path(player_name, section_key, category)) do
      :not_set -> :ok
      _ -> :already_set
    end
  end

  defp get_player_scoreboard_path(player_name, section_key, category) do
    [
      :players,
      player_name,
      Access.key(:scorecard),
      Access.key(section_key),
      Access.key(category)
    ]
  end
end
