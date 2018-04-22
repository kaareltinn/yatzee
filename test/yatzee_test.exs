defmodule YatzeeTest do
  use ExUnit.Case
  doctest Yatzee

  alias Dices.Dice

  test "add_player() returns add new player to the game" do
    game = Yatzee.new_game() |> Yatzee.add_player("Frank")

    assert %{
             players: %{
               0 => %{
                 name: "Frank",
                 scorecard: %Yatzee.Scorecard{},
                 turns_left: 13,
                 player_tag: 0
               }
             }
           } = game
  end

  describe "choose" do
    test "updates corresponding field when dices match" do
      game = Yatzee.new_game(["Frank"])

      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)

      assert {:ok,
              %{
                players: %{
                  0 => %{
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

      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 4, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)

      assert {:no_match,
              %{
                players: %{
                  0 => %{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: 0
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, :three_of_a_kind)
    end

    test "does not update field when already set" do
      game = Yatzee.new_game(["Frank"])

      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      game = %{game | dices: dices}
      {:ok, game} = Yatzee.start_game(game)

      {:ok, game} = Yatzee.choose(game, :three_of_a_kind)

      dices = %{
        one: %Dice{face: 6, name: :one},
        two: %Dice{face: 6, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      game = %{game | dices: dices}

      assert {:already_set, ^game} = Yatzee.choose(game, :three_of_a_kind)
    end
  end
end
