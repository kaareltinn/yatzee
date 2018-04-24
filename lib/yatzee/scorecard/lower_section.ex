defmodule Yatzee.Scorecard.LowerSection do
  defstruct three_of_a_kind:  :not_set,
            four_of_a_kind:   :not_set,
            full_house:       :not_set,
            small_straight:   :not_set,
            large_straight:   :not_set,
            yahtzee:          :not_set,
            chance:           :not_set

  def full?(lower_section) do
    lower_section
    |> Map.to_list
    |> Enum.all?(fn {_, v} -> is_integer(v) end)
  end
end
