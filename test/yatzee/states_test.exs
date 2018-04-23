defmodule Yatzee.StatesTest do
  use ExUnit.Case

  test "{:add_player, state: :initializing} -> :waiting_for_players" do
    game = Yatzee.new_game([])

    assert {:ok, %{state: :waiting_for_players}} = Yatzee.States.check(:add_player, game)
  end

  test "{:add_player, state: :waiting_for_player} -> :waiting_for_players" do
    game = Yatzee.new_game([])
    game = %{game | state: :waiting_for_players}

    assert {:ok, %{state: :waiting_for_players}} = Yatzee.States.check(:add_player, game)
  end

  test "{:start_game, state: :waiting_for_player} -> {:throwing_1, player_1}" do
    game = Yatzee.new_game(["Joe"])

    assert {:ok, %{state: {:throwing_1, %{name: "Joe", player_tag: 0}}}} =
             Yatzee.States.check(:start_game, game)
  end

  test "{:throw, {:throwing_1, player_1}} -> {:throwing_2, player_1}" do
    game = Yatzee.new_game(["Joe"])
    {:ok, game} = Yatzee.States.check(:start_game, game)

    assert {:ok, %{state: {:throwing_2, %{name: "Joe", player_tag: 0}}}} =
             Yatzee.States.check(:throw, game)
  end

  test "{:throw, {:throwing_2, player_1}} -> {:throwing_3, player_1}" do
    game = Yatzee.new_game(["Joe"])
    {:ok, game} = Yatzee.States.check(:start_game, game)
    {:ok, game} = Yatzee.States.check(:throw, game)

    assert {:ok, %{state: {:throwing_3, %{name: "Joe", player_tag: 0}}}} =
             Yatzee.States.check(:throw, game)
  end

  test "{:throw, {:throwing_3, player_1}} -> {:choosing, player_1}" do
    game = Yatzee.new_game(["Joe"])
    {:ok, game} = Yatzee.States.check(:start_game, game)
    {:ok, game} = Yatzee.States.check(:throw, game)
    {:ok, game} = Yatzee.States.check(:throw, game)

    assert {:ok, %{state: {:choosing, %{name: "Joe", player_tag: 0}}}} =
             Yatzee.States.check(:throw, game)
  end

  test "{:choose, {_, current_player}} -> {:throwing_1, next_player}" do
    game = Yatzee.new_game(["Joe", "Mike", "Dave"])

    {:ok, game} = Yatzee.States.check(:start_game, game)
    {:ok, game} = Yatzee.States.check(:throw, game)

    assert {:ok, %{state: {:throwing_1, %{name: "Mike"}}} = game} = Yatzee.States.check(:choose, game)
    assert {:ok, %{state: {:throwing_1, %{name: "Dave"}}} = game} = Yatzee.States.check(:choose, game)
    assert {:ok, %{state: {:throwing_1, %{name: "Joe"}}}} = Yatzee.States.check(:choose, game)
  end
end
