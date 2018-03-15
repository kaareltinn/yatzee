defmodule Yatzee.RulesTest do
  use ExUnit.Case

  alias Dices.Dice
  alias Yatzee.Rules

  describe "when three same faces check :three_of_a_kind" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :three_of_a_kind, 15} = Rules.check(dices, :three_of_a_kind)
    end
  end

  describe "when dices do not have three of a kind" do
    test "returns error tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 3, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :three_of_a_kind} = Rules.check(dices, :three_of_a_kind)
    end
  end

  describe "when more than three dices have same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :three_of_a_kind, 15} = Rules.check(dices, :three_of_a_kind)
    end
  end
end
