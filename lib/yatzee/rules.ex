defmodule Yatzee.Rules do
  def call(dices) do
    [dices, []]
    |> check(:three_of_a_kind)
    |> check(:four_of_a_kind)
    |> check(:yahtzee)
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

  defp success_response(value, category), do:
    {:ok, category, value}
end
