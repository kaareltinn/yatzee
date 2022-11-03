defmodule Yatzee.States do
  def check(:add_player, %{state: :initializing} = game_state) do
    success_response(game_state, :waiting_for_players)
  end

  def check(:add_player, %{state: :waiting_for_players} = game_state) do
    success_response(game_state, :waiting_for_players)
  end

  def check(:start_game, %{state: :waiting_for_players} = game_state) do
    game_state = initialize_players_turns(game_state)
    {next_player, upcoming} = get_next_player(game_state)
    success_response(%{game_state | players_turns: upcoming}, {:throwing_1, next_player})
  end

  def check(:throw, %{state: {:throwing_1, player}} = game_state) do
    success_response(game_state, {:throwing_2, player})
  end

  def check(:throw, %{state: {:throwing_2, player}} = game_state) do
    success_response(game_state, {:throwing_3, player})
  end

  def check(:throw, %{state: {:throwing_3, player}} = game_state) do
    success_response(game_state, {:choosing, player})
  end

  def check(:choose, %{state: {_, _current_player}} = game_state) do
    if game_finished?(game_state) do
      success_response(game_state, :finished)
    else
      {next_player, upcoming} = get_next_player(game_state)

      success_response(
        %{game_state | players_turns: upcoming},
        {:throwing_1, next_player}
      )
    end
  end

  def check(_, game_state) do
    {:invalid_action, game_state}
  end

  defp get_next_player(game_state) do
    [current | upcoming] = game_state.players_turns
    {current, upcoming}
  end

  defp initialize_players_turns(game_state) do
    players_turns =
      game_state.players
      |> Map.values()
      |> Enum.sort_by(& &1.player_tag)
      |> Stream.cycle()
      |> Enum.take(Enum.count(game_state.players) * 13)
      |> Enum.map(& &1.name)

    %{game_state | players_turns: players_turns}
  end

  defp success_response(game_state, state) do
    {:ok, %{game_state | state: state}}
  end

  def game_finished?(game_state) do
    Enum.all?(game_state.players, fn {_, player} -> Yatzee.Scorecard.full?(player.scorecard) end)
  end
end
