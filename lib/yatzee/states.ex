defmodule Yatzee.States do
  def check(:add_player, %{state: :initializing} = game_state) do
    %{game_state | state: :waiting_for_players}
  end

  def check(:add_player, %{state: :waiting_for_players} = game_state) do
    game_state
  end

  def check(:start_game, %{state: :waiting_for_players} = game_state) do
    %{game_state | state: {:throwing_1, get_next_player(game_state)}}
  end

  def check(:throw, %{state: {:throwing_1, player}} = game_state) do
    %{game_state | state: {:throwing_2, player}}
  end

  def check(:throw, %{state: {:throwing_2, player}} = game_state) do
    %{game_state | state: {:throwing_3, player}}
  end

  def check(:throw, %{state: {:throwing_3, player}} = game_state) do
    %{game_state | state: {:choosing, player}}
  end

  def check(:choose, %{state: {_, player}} = game_state) do
    %{game_state | state: {:throwing_1, get_next_player(game_state, player)}}
  end

  defp get_next_player(game, %{player_tag: current_player_tag}) do
    next_player_tag = current_player_tag + 1
    Map.get(game.player, next_player_tag, game.players[0])
  end

  defp get_next_player(game), do: game.players[0]
end
