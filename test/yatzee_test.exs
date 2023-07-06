defmodule YatzeeTest do
  use ExUnit.Case, async: false
  doctest Yatzee

  alias Yatzee.Dices.Dice

  setup do
    game_name = "game_#{System.unique_integer([:positive])}"
    game_pid = start_supervised!({Yatzee.Game, game_name}, restart: :temporary)

    {:ok, game_pid: game_pid, game_name: game_name}
  end

  test "new_game/1 returns new game with players", %{game_pid: game_pid, game_name: game_name} do
    Yatzee.add_player(game_name, "John")
    Yatzee.add_player(game_name, "Mike")

    assert %{
             players: %{
               "John" => %Yatzee.Player{
                 name: "John",
                 scorecard: %Yatzee.Scorecard{},
                 player_tag: 0
               },
               "Mike" => %Yatzee.Player{
                 name: "Mike",
                 scorecard: %Yatzee.Scorecard{},
                 player_tag: 1
               }
             }
           } = get_game_state(game_pid)
  end

  test "start_game()", %{game_pid: game_pid, game_name: game_name} do
    assert %{state: :initializing} = get_game_state(game_pid)

    Yatzee.add_player(game_name, "Frank")

    assert %{state: :waiting_for_players} = get_game_state(game_pid)

    Yatzee.start_game(game_name)

    assert %{state: {:throwing_1, "Frank"}} = get_game_state(game_pid)
  end

  test "throw()", %{game_pid: game_pid, game_name: game_name} do
    Yatzee.add_player(game_name, "Frank")
    Yatzee.start_game(game_name)

    assert %{state: {:throwing_1, "Frank"}} = get_game_state(game_pid)

    Yatzee.throw(game_name, [:one, :two, :three])

    assert %{state: {:throwing_2, "Frank"}} = get_game_state(game_pid)

    Yatzee.throw(game_name, [:four, :five])

    assert %{state: {:throwing_3, "Frank"}} = get_game_state(game_pid)

    Yatzee.throw(game_name, [])

    game_state = get_game_state(game_pid)

    assert %{state: {:choosing, "Frank"}} = game_state

    {:invalid_action,
     [
       %Yatzee.Dices.Dice{},
       %Yatzee.Dices.Dice{},
       %Yatzee.Dices.Dice{},
       %Yatzee.Dices.Dice{},
       %Yatzee.Dices.Dice{}
     ]} = Yatzee.throw(game_name, [])

    assert game_state == get_game_state(game_pid)
  end

  describe "choose/2" do
    test "updates corresponding field when dices match", %{
      game_pid: game_pid,
      game_name: game_name
    } do
      Yatzee.add_player(game_name, "Frank")
      Yatzee.add_player(game_name, "Jenny")

      Yatzee.start_game(game_name)

      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game_state = get_game_state(game_pid)
      game_state = %{game_state | dices: dices}
      :sys.replace_state(game_pid, fn _ -> game_state end)

      Yatzee.choose(game_name, :three_of_a_kind)

      assert %{
               players: %{
                 "Frank" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: 22
                     }
                   }
                 },
                 "Jenny" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: :not_set
                     }
                   }
                 }
               }
             } = get_game_state(game_pid)
    end

    test "does not update field when dices do not match", %{
      game_pid: game_pid,
      game_name: game_name
    } do
      Yatzee.add_player(game_name, "Frank")
      Yatzee.add_player(game_name, "Jenny")

      Yatzee.start_game(game_name)

      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 2, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game_state = get_game_state(game_pid)
      game_state = %{game_state | dices: dices}
      :sys.replace_state(game_pid, fn _ -> game_state end)

      {:no_match, _game_state} = Yatzee.choose(game_name, :three_of_a_kind)

      assert %{
               players: %{
                 "Frank" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: :not_set
                     }
                   }
                 },
                 "Jenny" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: :not_set
                     }
                   }
                 }
               }
             } = get_game_state(game_pid)
    end

    test "does not update field when already set", %{game_pid: game_pid, game_name: game_name} do
      Yatzee.add_player(game_name, "Frank")
      Yatzee.add_player(game_name, "Jenny")

      Yatzee.start_game(game_name)

      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])
      Yatzee.throw(game_name, [])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game_state = get_game_state(game_pid)
      game_state = %{game_state | dices: dices}
      :sys.replace_state(game_pid, fn _ -> game_state end)

      Yatzee.choose(game_name, :three_of_a_kind)

      assert %{
               players: %{
                 "Frank" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: 22
                     }
                   }
                 },
                 "Jenny" => %Yatzee.Player{
                   scorecard: %Yatzee.Scorecard{
                     lower_section: %Yatzee.Scorecard.LowerSection{
                       three_of_a_kind: :not_set
                     }
                   }
                 }
               }
             } = get_game_state(game_pid)

      # Jenny thorws all dices
      Yatzee.throw(game_name, [])

      Yatzee.choose(game_name, :ones)

      # Frank thorws all dices
      Yatzee.throw(game_name, [])

      game_state = get_game_state(game_pid)
      :sys.replace_state(game_pid, fn _ -> game_state end)

      {:no_match, _game_state} = Yatzee.choose(game_name, :three_of_a_kind)
    end

    test "does not update if invalid action", %{game_pid: game_pid, game_name: game_name} do
      Yatzee.add_player(game_name, "Frank")
      Yatzee.start_game(game_name)

      dices = [
        %Dice{face: 6, name: :one},
        %Dice{face: 6, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 2, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game_state = get_game_state(game_pid)
      game_state = %{game_state | dices: dices}
      game_state = %{game_state | state: {:throwing_1, "Frank"}}

      :sys.replace_state(game_pid, fn _ -> game_state end)

      assert {:invalid_action, _game} = Yatzee.choose(game_name, :three_of_a_kind)
    end
  end

  defp get_game_state(pid) do
    :sys.get_state(pid)
  end
end
