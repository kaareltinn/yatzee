defmodule Yatzee.RulesTest do
  use ExUnit.Case

  alias Dices.Dice
  alias Yatzee.Rules

  ###################
  # :ones #
  ###################
  describe "when one dice have one" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :ones, 1} = Rules.check(dices, :ones)
    end
  end

  describe "when more than one dice have one" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 1, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :ones, 3} = Rules.check(dices, :ones)
    end
  end

  describe "when no dice have one" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 2, name: :five}
      }

      assert {:no_match, :ones} = Rules.check(dices, :ones)
    end
  end

  ###################
  # :three_of_a_kind #
  ###################
  describe "when three same faces check :three_of_a_kind" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :three_of_a_kind, 22} = Rules.check(dices, :three_of_a_kind)
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

      assert {:ok, :three_of_a_kind, 21} = Rules.check(dices, :three_of_a_kind)
    end
  end

  ###################
  # :four_of_a_kind #
  ###################
  describe "when four dices have same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :four_of_a_kind, 21} = Rules.check(dices, :four_of_a_kind)
    end
  end

  describe "when less than four dices have same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 4, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :four_of_a_kind} = Rules.check(dices, :four_of_a_kind)
    end
  end

  describe "when more than four dices have same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 5, name: :five}
      }

      assert {:ok, :four_of_a_kind, 25} = Rules.check(dices, :four_of_a_kind)
    end
  end

  ###################
  # :full_house #
  ###################
  describe "when dices contain full house" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 1, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :full_house, 25} = Rules.check(dices, :full_house)
    end
  end

  describe "when dices do not contain full house" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 4, name: :three},
        four: %Dice{face: 1, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :full_house} = Rules.check(dices, :full_house)
    end
  end

  ###################
  # :small_straight #
  ###################
  describe "when dices have 1-2-3-4" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 3, name: :three},
        four: %Dice{face: 4, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  describe "when dices have 2-3-4-5" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 3, name: :two},
        three: %Dice{face: 4, name: :three},
        four: %Dice{face: 2, name: :four},
        five: %Dice{face: 6, name: :five}
      }

      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  describe "when dices have 3-4-5-6" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 4, name: :one},
        two: %Dice{face: 3, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 6, name: :five}
      }

      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  ###################
  # :large_straight #
  ###################
  describe "when dices have 1-2-3-4-5" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 3, name: :three},
        four: %Dice{face: 4, name: :four},
        five: %Dice{face: 5, name: :five}
      }

      assert {:ok, :large_straight, 40} = Rules.check(dices, :large_straight)
    end
  end

  describe "when dices have 2-3-4-5-6" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 4, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 2, name: :five}
      }

      assert {:ok, :large_straight, 40} = Rules.check(dices, :large_straight)
    end
  end
end
