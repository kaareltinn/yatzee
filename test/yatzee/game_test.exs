defmodule Yatzee.GameTest do
  use ExUnit.Case, async: true

  alias Yatzee.Game

  test "cannot create games with same name" do
    game_name = generate_game_name()

    assert {:ok, pid} = Game.start_link(game_name)
    assert {:error, {:already_started, ^pid}} = Game.start_link(game_name)
  end

  defp generate_game_name do
    "game-#{:rand.uniform(1_000_000)}"
  end
end
