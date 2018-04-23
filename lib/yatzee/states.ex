defmodule Yatzee.States do
  def check(:add_player, %{state: :initializing} = game_state) do
    success_response(game_state, :waiting_for_players)
  end

  def check(:add_player, %{state: :waiting_for_players} = game_state) do
    success_response(game_state, :waiting_for_players)
  end

  def check(:start_game, %{state: :waiting_for_players} = game_state) do
    success_response(game_state, {:throwing_1, get_next_player(game_state)})
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

  def check(:choose, %{state: {_, current_player}} = game_state) do
    success_response(
      game_state,
      {:throwing_1, get_next_player(game_state, current_player)}
    )
  end

  def check(_, game_state) do
    {:invalid_action, game_state}
  end

  defp get_next_player(game_state, %{player_tag: current_player_tag} = player) do
    next_player_tag = current_player_tag + 1
    player = Map.get(game_state.players, next_player_tag, game_state.players[0])
    %{
      name: player.name,
      player_tag: player.player_tag
    }
  end

  defp get_next_player(game_state) do
    player = game_state.players[0]
    %{
      name: player.name,
      player_tag: player.player_tag
    }
  end

  defp success_response(game_state, state) do
    {:ok, %{game_state | state: state}}
  end
end
