defmodule YatzeeTest do
  use ExUnit.Case
  doctest Yatzee

  alias Dices.Dice

  test "new_game() returns new game" do
    game = Yatzee.new_game(["Frank"])

    assert %{
             players: %{
               "Frank" => %{name: "Frank", scorecard: %Yatzee.Scorecard{}, turns_left: 13}
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

      assert {:ok,
              %{
                players: %{
                  "Frank" => %{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: 22
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, "Frank", :three_of_a_kind)
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

      assert {:no_match,
              %{
                players: %{
                  "Frank" => %{
                    scorecard: %Yatzee.Scorecard{
                      lower_section: %Yatzee.Scorecard.LowerSection{
                        three_of_a_kind: 0
                      }
                    }
                  }
                }
              }} = Yatzee.choose(game, "Frank", :three_of_a_kind)
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

      {:ok, game} = Yatzee.choose(game, "Frank", :three_of_a_kind)

      dices = %{
        one: %Dice{face: 6, name: :one},
        two: %Dice{face: 6, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      game = %{game | dices: dices}

      assert {:already_set, ^game} = Yatzee.choose(game, "Frank", :three_of_a_kind)
    end
  end
end
