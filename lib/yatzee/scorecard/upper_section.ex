defmodule Yatzee.Scorecard.UpperSection do
  defstruct ones:     :not_set,
            twos:     :not_set,
            threes:   :not_set,
            fours:    :not_set,
            fives:    :not_set,
            sixes:    :not_set

  def full?(upper_section) do
    upper_section
    |> Map.to_list
    |> Enum.all?(fn {_, v} -> is_integer(v) end)
  end
end
