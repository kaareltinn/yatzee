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
    |> Enum.filter(fn {_, dices} -> Enum.count(dices) >= 3 end)
    |> verdict(:three_of_a_kind)
  end

  defp verdict(dices, :three_of_a_kind) do
    if Enum.any?(dices) do
      dices
      |> Enum.reduce(0, fn {_, dices}, sum -> sum + dices_sum(dices, 3) end)
      |> success_response(:three_of_a_kind)
    else
      {:no_match, :three_of_a_kind}
    end
  end

  defp dices_sum(dices, num) do
    dices
    |> Enum.take(num)
    |> Dices.sum()
  end

  defp success_response(value, category), do:
    {:ok, category, value}
end
