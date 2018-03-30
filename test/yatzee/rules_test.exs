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
    test "returns no match tuple" do
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
  # :twos #
  ###################
  describe "when one dice have 2" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :twos, 2} = Rules.check(dices, :twos)
    end
  end

  describe "when more than one dice have 2" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 2, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 2, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :twos, 6} = Rules.check(dices, :twos)
    end
  end

  describe "when no dice have 2" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :twos} = Rules.check(dices, :twos)
    end
  end

  ###################
  # :threes #
  ###################
  describe "when one dice have 3" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :threes, 3} = Rules.check(dices, :threes)
    end
  end

  describe "when more than one dice have 3" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 2, name: :one},
        two: %Dice{face: 3, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 3, name: :four},
        five: %Dice{face: 3, name: :five}
      }

      assert {:ok, :threes, 9} = Rules.check(dices, :threes)
    end
  end

  describe "when no dice have 3" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :threes} = Rules.check(dices, :threes)
    end
  end

  ###################
  # :fours #
  ###################
  describe "when one dice have 4" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 4, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :fours, 4} = Rules.check(dices, :fours)
    end
  end

  describe "when more than one dice have 4" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 4, name: :one},
        two: %Dice{face: 4, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 3, name: :four},
        five: %Dice{face: 4, name: :five}
      }

      assert {:ok, :fours, 12} = Rules.check(dices, :fours)
    end
  end

  describe "when no dice have 4" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 5, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :fours} = Rules.check(dices, :fours)
    end
  end

  ###################
  # :fives #
  ###################
  describe "when one dice have 5" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :fives, 5} = Rules.check(dices, :fives)
    end
  end

  describe "when more than one dice have 5" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 2, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 3, name: :five}
      }

      assert {:ok, :fives, 10} = Rules.check(dices, :fives)
    end
  end

  describe "when no dice have 5" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 3, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :fives} = Rules.check(dices, :fives)
    end
  end

  ###################
  # :sixes #
  ###################
  describe "when one dice have 6" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :sixes, 6} = Rules.check(dices, :sixes)
    end
  end

  describe "when more than one dice have 6" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 6, name: :one},
        two: %Dice{face: 6, name: :two},
        three: %Dice{face: 2, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 6, name: :five}
      }

      assert {:ok, :sixes, 24} = Rules.check(dices, :sixes)
    end
  end

  describe "when no dice have 6" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 2, name: :two},
        three: %Dice{face: 3, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:no_match, :sixes} = Rules.check(dices, :sixes)
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
    test "returns no match tuple" do
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
    test "returns no match tuple" do
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
    test "returns no match tuple" do
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

  describe "when dices do not have small straight" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 4, name: :one},
        two: %Dice{face: 5, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 5, name: :four},
        five: %Dice{face: 6, name: :five}
      }

      assert {:no_match, :small_straight} = Rules.check(dices, :small_straight)
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

  describe "when dices do not have large straight" do
    test "returns no match tuple" do
      dices = %{
        one: %Dice{face: 2, name: :one},
        two: %Dice{face: 4, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 2, name: :five}
      }

      assert {:no_match, :large_straight} = Rules.check(dices, :large_straight)
    end
  end

  ###################
  # :yahtzee #
  ###################
  describe "when dices have all same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 1, name: :one},
        two: %Dice{face: 1, name: :two},
        three: %Dice{face: 1, name: :three},
        four: %Dice{face: 1, name: :four},
        five: %Dice{face: 1, name: :five}
      }

      assert {:ok, :yahtzee, 50} = Rules.check(dices, :yahtzee)
    end
  end

  describe "when dices have do not have same face" do
    test "returns success tuple" do
      dices = %{
        one: %Dice{face: 3, name: :one},
        two: %Dice{face: 4, name: :two},
        three: %Dice{face: 5, name: :three},
        four: %Dice{face: 6, name: :four},
        five: %Dice{face: 2, name: :five}
      }

      assert {:no_match, :yahtzee} = Rules.check(dices, :yahtzee)
    end
  end

  ###################
  # :chance #
  ###################
  test "returns success tuple" do
    dices = %{
      one: %Dice{face: 1, name: :one},
      two: %Dice{face: 2, name: :two},
      three: %Dice{face: 3, name: :three},
      four: %Dice{face: 4, name: :four},
      five: %Dice{face: 5, name: :five}
    }

    assert {:ok, :chance, 15} = Rules.check(dices, :chance)
  end
end
