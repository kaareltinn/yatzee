defmodule YatzeeTest do
  use ExUnit.Case
  doctest Yatzee

  alias Yatzee.Dices.Dice

  test "new_game/1 returns new game with players" do
    game = Yatzee.new_game(["John", "Mike"])

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
           } = game
  end

  test "add_player() returns add new player to the game" do
    {:ok, game} = Yatzee.new_game() |> Yatzee.add_player("Frank")

    assert %{
             players: %{
               "Frank" => %Yatzee.Player{
                 name: "Frank",
                 scorecard: %Yatzee.Scorecard{},
                 player_tag: 0
               }
             }
           } = game

    {:ok, game} = Yatzee.add_player(game, "Mike")

    assert %{
             players: %{
               "Frank" => %Yatzee.Player{
                 name: "Frank",
                 scorecard: %Yatzee.Scorecard{},
                 player_tag: 0
               },
               "Mike" => %Yatzee.Player{
                 name: "Mike",
                 scorecard: %Yatzee.Scorecard{},
                 player_tag: 1
               }
             }
           } = game
  end

  test "start_game()" do
    {:ok, game} =
      Yatzee.new_game()
      |> Yatzee.add_player("Frank")

    assert %{state: :waiting_for_players} = game

    {:ok, game} = Yatzee.start_game(game)

    assert %{state: {:throwing_1, "Frank"}} = game
  end

  test "throw()" do
    {:ok, game} =
      Yatzee.new_game()
      |> Yatzee.add_player("Frank")

    assert %{state: :waiting_for_players} = game

    {:ok, game} = Yatzee.start_game(game)

    assert %{state: {:throwing_1, "Frank"}} = game

    {:ok, game} = Yatzee.throw(game, [:one, :two, :three])

    assert Enum.count(game.dices) == 5
  end

  describe "choose" do
    test "updates corresponding field when dices match" do
      game = Yatzee.new_game(["Frank"])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)
      game = %{game | state: {:choosing, "Frank"}}

      assert {:ok,
              %{
                players: %{
                  "Frank" => %Yatzee.Player{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: 22
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, :three_of_a_kind)
    end

    test "updates correct player's scoreboard" do
      game = Yatzee.new_game(["Frank", "Jenny"])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)
      game = %{game | state: {:choosing, "Frank"}}

      assert {:ok,
              %{
                players: %{
                  "Frank" => %Yatzee.Player{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: 22
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, :three_of_a_kind)
    end

    test "does not update field when dices do not match" do
      game = Yatzee.new_game(["Frank"])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 2, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)
      game = %{game | state: {:choosing, "Frank"}}

      assert {:no_match,
              %{
                players: %{
                  "Frank" => %Yatzee.Player{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: :not_set
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, :three_of_a_kind)
    end

    test "does not update field when already set" do
      game = Yatzee.new_game(["Frank"])

      dices = [
        %Dice{face: 5, name: :one},
        %Dice{face: 5, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)
      game = %{game | state: {:choosing, "Frank"}}

      {:ok, game} = Yatzee.choose(game, :three_of_a_kind)

      dices = [
        %Dice{face: 6, name: :one},
        %Dice{face: 6, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 6, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      game = %{game | state: {:choosing, "Frank"}}

      assert {:already_set, ^game} = Yatzee.choose(game, :three_of_a_kind)
    end

    test "does not update if invalid action" do
      game = Yatzee.new_game(["Frank"])

      dices = [
        %Dice{face: 6, name: :one},
        %Dice{face: 6, name: :two},
        %Dice{face: 5, name: :three},
        %Dice{face: 2, name: :four},
        %Dice{face: 1, name: :five}
      ]

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)
      game = %{game | state: {:throwing_1, "Frank"}}

      assert {:invalid_action, ^game} = Yatzee.choose(game, :three_of_a_kind)
    end
  end
end
