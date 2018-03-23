defmodule Yatzee.Rules do
  def call(dices) do
    [dices, []]
    |> check(:three_of_a_kind)
    |> check(:four_of_a_kind)
    |> check(:yahtzee)
  end

  def check(dices, :ones) do
    dices
    |> Enum.group_by(fn {_, %Dices.Dice{face: face}} -> face end)
    |> verdict(:ones)
  end

  def check(dices, :three_of_a_kind) do
    dices
    |> Enum.group_by(fn {_, %Dices.Dice{face: face}} -> face end)
    |> verdict(:three_of_a_kind)
  end

  def check(dices, :four_of_a_kind) do
    dices
    |> Enum.group_by(fn {_, %Dices.Dice{face: face}} -> face end)
    |> verdict(:four_of_a_kind)
  end

  def check(dices, :full_house) do
    dices
    |> Enum.group_by(fn {_, %Dices.Dice{face: face}} -> face end)
    |> Enum.map(fn {_, dices} -> Enum.count(dices) end)
    |> verdict(:full_house)
  end

  def check(dices, :small_straight) do
    dices
    |> Enum.map(fn {_, %Dices.Dice{face: face}} -> face end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.take(4)
    |> verdict(:small_straight)
  end

  def check(dices, :large_straight) do
    dices
    |> Enum.map(fn {_, %Dices.Dice{face: face}} -> face end)
    |> Enum.sort()
    |> Enum.uniq()
    |> verdict(:large_straight)
  end

  defp verdict(dices, :ones) do
    if Enum.any?(dices, fn {face, _} -> face == 1 end) do
      dices
      |> Map.get(1)
      |> Dices.sum()
      |> success_response(:ones)
    else
      {:no_match, :ones}
    end
  end

  defp verdict(dices, :three_of_a_kind) do
    if Enum.any?(dices, fn {_, dices} -> Enum.count(dices) >= 3 end) do
      dices
      |> Map.values()
      |> List.flatten()
      |> Dices.sum()
      |> success_response(:three_of_a_kind)
    else
      {:no_match, :three_of_a_kind}
    end
  end

  defp verdict(dices, :four_of_a_kind) do
    if Enum.any?(dices, fn {_, dices} -> Enum.count(dices) >= 4 end) do
      dices
      |> Map.values()
      |> List.flatten()
      |> Dices.sum()
      |> success_response(:four_of_a_kind)
    else
      {:no_match, :four_of_a_kind}
    end
  end

  defp verdict([2, 3], :full_house) do
    success_response(25, :full_house)
  end
  defp verdict([3, 2], :full_house) do
    success_response(25, :full_house)
  end
  defp verdict(_, :full_house) do
    {:no_match, :full_house}
  end

  defp verdict([1, 2, 3, 4], :small_straight) do
    success_response(30, :small_straight)
  end
  defp verdict([2, 3, 4, 5], :small_straight) do
    success_response(30, :small_straight)
  end
  defp verdict([3, 4, 5, 6], :small_straight) do
    success_response(30, :small_straight)
  end

  defp verdict([1, 2, 3, 4, 5], :large_straight) do
    success_response(40, :large_straight)
  end
  defp verdict([2, 3, 4, 5, 6], :large_straight) do
    success_response(40, :large_straight)
  end

  defp success_response(value, category), do:
    {:ok, category, value}
end
