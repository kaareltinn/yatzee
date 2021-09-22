defmodule Yatzee.Dices do
  alias Yatzee.{Dices}

  def new do
    [:one, :two, :three, :four, :five]
    |> Enum.map(fn name -> %Dices.Dice{face: Enum.random(1..5), name: name} end)
  end

  def sum(dices) do
    Enum.reduce(dices, 0, fn {_, dice}, acc -> acc + dice.face end)
  end
end
