defmodule Yatzee.Dices do
  alias Yatzee.Dices.Dice

  def new do
    [:one, :two, :three, :four, :five]
    |> Enum.map(fn name -> %Dice{face: Enum.random(1..5), name: name} end)
  end

  def sum(dices) do
    Enum.reduce(dices, 0, fn dice, acc -> acc + dice.face end)
  end

  def throw(dices, dice_names) do
    dices
    |> Enum.map(fn %Dice{name: name} = dice ->
      if Enum.member?(dice_names, name) do
        %Dice{dice | face: Enum.random(1..6)}
      else
        dice
      end
    end)
  end
end
