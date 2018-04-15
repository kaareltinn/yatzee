defmodule Yatzee.StatesTest do
  use ExUnit.Case

  test "{:add_player, state: :initializing} -> :waiting_for_players" do
    game = Yatzee.new_game([])

    assert %{state: :waiting_for_players} = Yatzee.States.check(:add_player, game)
  end

  test "{:add_player, state: :waiting_for_player} -> :waiting_for_players" do
    game = Yatzee.new_game([])
    game = %{game | state: :waiting_for_players}

    assert %{state: :waiting_for_players} = Yatzee.States.check(:add_player, game)
  end

  test "{:start_game, state: :waiting_for_player} -> {:throwing_1, player_1}" do
    game = Yatzee.new_game(["Joe"])

    assert %{state: {:throwing_1, %{name: "Joe", turns_left: 13}}} =
             Yatzee.States.check(:start_game, game)
  end

  test "{:throw, {:throwing_1, player_1}} -> {:throwing_2, player_1}" do
    game = Yatzee.new_game(["Joe"])
    game = Yatzee.States.check(:start_game, game)

    assert %{state: {:throwing_2, %{name: "Joe", turns_left: 13}}} =
             Yatzee.States.check(:throw, game)
  end

  test "{:throw, {:throwing_2, player_1}} -> {:throwing_3, player_1}" do
    game = Yatzee.new_game(["Joe"])
    game = Yatzee.States.check(:start_game, game)
    game = Yatzee.States.check(:throw, game)

    assert %{state: {:throwing_3, %{name: "Joe", turns_left: 13}}} =
             Yatzee.States.check(:throw, game)
  end

  test "{:throw, {:throwing_3, player_1}} -> {:choosing, player_1}" do
    game = Yatzee.new_game(["Joe"])
    game = Yatzee.States.check(:start_game, game)
    game = Yatzee.States.check(:throw, game)
    game = Yatzee.States.check(:throw, game)

    assert %{state: {:choosing, %{name: "Joe", turns_left: 13}}} =
             Yatzee.States.check(:throw, game)
  end
end
