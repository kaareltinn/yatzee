defmodule Yatzee.RulesTest do
  use ExUnit.Case

  alias Yatzee.Dices.Dice
  alias Yatzee.Rules

  setup %{faces: faces} do
    names = [:one, :two, :three, :four, :five]

    dices =
      List.zip([faces, names])
      |> Enum.map(fn {face, name} -> %Dice{face: face, name: name} end)

    %{dices: dices}
  end

  ###################
  # :ones #
  ###################
  describe "when one dice have one" do
    @tag faces: [5, 5, 5, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :ones, 1} = Rules.check(dices, :ones)
    end
  end

  describe "when more than one dice have one" do
    @tag faces: [1, 1, 5, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :ones, 3} = Rules.check(dices, :ones)
    end
  end

  describe "when no dice have one" do
    @tag faces: [5, 5, 5, 6, 2]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :ones} = Rules.check(dices, :ones)
    end
  end

  ###################
  # :twos #
  ###################
  describe "when one dice have 2" do
    @tag faces: [5, 5, 2, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :twos, 2} = Rules.check(dices, :twos)
    end
  end

  describe "when more than one dice have 2" do
    @tag faces: [2, 5, 2, 2, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :twos, 6} = Rules.check(dices, :twos)
    end
  end

  describe "when no dice have 2" do
    @tag faces: [1, 5, 1, 1, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :twos} = Rules.check(dices, :twos)
    end
  end

  ###################
  # :threes #
  ###################
  describe "when one dice have 3" do
    @tag faces: [3, 2, 2, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :threes, 3} = Rules.check(dices, :threes)
    end
  end

  describe "when more than one dice have 3" do
    @tag faces: [3, 2, 3, 3, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :threes, 9} = Rules.check(dices, :threes)
    end
  end

  describe "when no dice have 3" do
    @tag faces: [5, 5, 5, 6, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :threes} = Rules.check(dices, :threes)
    end
  end

  ###################
  # :fours #
  ###################
  describe "when one dice have 4" do
    @tag faces: [3, 2, 2, 4, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :fours, 4} = Rules.check(dices, :fours)
    end
  end

  describe "when more than one dice have 4" do
    @tag faces: [4, 4, 2, 4, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :fours, 12} = Rules.check(dices, :fours)
    end
  end

  describe "when no dice have 4" do
    @tag faces: [5, 5, 5, 6, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :fours} = Rules.check(dices, :fours)
    end
  end

  ###################
  # :fives #
  ###################
  describe "when one dice have 5" do
    @tag faces: [2, 3, 5, 1, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :fives, 5} = Rules.check(dices, :fives)
    end
  end

  describe "when more than one dice have 5" do
    @tag faces: [2, 3, 5, 1, 5]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :fives, 10} = Rules.check(dices, :fives)
    end
  end

  describe "when no dice have 5" do
    @tag faces: [2, 3, 3, 1, 6]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :fives} = Rules.check(dices, :fives)
    end
  end

  ###################
  # :sixes #
  ###################
  describe "when one dice have 6" do
    @tag faces: [3, 2, 5, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :sixes, 6} = Rules.check(dices, :sixes)
    end
  end

  describe "when more than one dice have 6" do
    @tag faces: [6, 6, 6, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :sixes, 24} = Rules.check(dices, :sixes)
    end
  end

  describe "when no dice have 6" do
    @tag faces: [1, 2, 3, 5, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :sixes} = Rules.check(dices, :sixes)
    end
  end

  ###################
  # :three_of_a_kind #
  ###################
  describe "when three same faces check :three_of_a_kind" do
    @tag faces: [5, 5, 5, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :three_of_a_kind, 22} = Rules.check(dices, :three_of_a_kind)
    end
  end

  describe "when dices do not have three of a kind" do
    @tag faces: [5, 3, 5, 6, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:no_match, :three_of_a_kind} = Rules.check(dices, :three_of_a_kind)
    end
  end

  describe "when more than three dices have same face" do
    @tag faces: [5, 5, 5, 5, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :three_of_a_kind, 21} = Rules.check(dices, :three_of_a_kind)
    end
  end

  ###################
  # :four_of_a_kind #
  ###################
  describe "when four dices have same face" do
    @tag faces: [5, 5, 5, 5, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :four_of_a_kind, 21} = Rules.check(dices, :four_of_a_kind)
    end
  end

  describe "when less than four dices have same face" do
    @tag faces: [5, 3, 5, 5, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :four_of_a_kind} = Rules.check(dices, :four_of_a_kind)
    end
  end

  describe "when more than four dices have same face" do
    @tag faces: [5, 5, 5, 5, 5]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :four_of_a_kind, 25} = Rules.check(dices, :four_of_a_kind)
    end
  end

  ###################
  # :full_house #
  ###################
  describe "when dices contain full house" do
    @tag faces: [5, 5, 5, 1, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :full_house, 25} = Rules.check(dices, :full_house)
    end
  end

  describe "when dices do not contain full house" do
    @tag faces: [5, 2, 5, 1, 1]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :full_house} = Rules.check(dices, :full_house)
    end
  end

  ###################
  # :small_straight #
  ###################
  describe "when dices have 1-2-3-4" do
    @tag faces: [1, 3, 5, 4, 2]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  describe "when dices have 2-3-4-5" do
    @tag faces: [5, 3, 4, 2, 6]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  describe "when dices have 3-4-5-6" do
    @tag faces: [4, 3, 5, 5, 6]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :small_straight, 30} = Rules.check(dices, :small_straight)
    end
  end

  describe "when dices do not have small straight" do
    @tag faces: [4, 5, 5, 5, 6]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :small_straight} = Rules.check(dices, :small_straight)
    end
  end

  ###################
  # :large_straight #
  ###################
  describe "when dices have 1-2-3-4-5" do
    @tag faces: [3, 4, 5, 1, 2]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :large_straight, 40} = Rules.check(dices, :large_straight)
    end
  end

  describe "when dices have 2-3-4-5-6" do
    @tag faces: [3, 4, 5, 6, 2]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :large_straight, 40} = Rules.check(dices, :large_straight)
    end
  end

  describe "when dices do not have large straight" do
    @tag faces: [2, 4, 5, 6, 2]
    test "returns no match tuple", %{dices: dices} do
      assert {:no_match, :large_straight} = Rules.check(dices, :large_straight)
    end
  end

  ###################
  # :yahtzee #
  ###################
  describe "when dices have all same face" do
    @tag faces: [1, 1, 1, 1, 1]
    test "returns success tuple", %{dices: dices} do
      assert {:ok, :yahtzee, 50} = Rules.check(dices, :yahtzee)
    end
  end

  describe "when dices have do not have same face" do
    @tag faces: [3, 4, 5, 6, 2]
    test "returns success tuple", %{dices: dices} do
      assert {:no_match, :yahtzee} = Rules.check(dices, :yahtzee)
    end
  end

  ###################
  # :chance #
  ###################
  @tag faces: [1, 2, 3, 4, 5]
  test "returns success tuple", %{dices: dices} do
    assert {:ok, :chance, 15} = Rules.check(dices, :chance)
  end
end
