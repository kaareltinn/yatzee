defmodule Yatzee.Scorecard do
  alias Yatzee.Scorecard
  alias Yatzee.Scorecard.{UpperSection, LowerSection}

  defstruct upper_section: %UpperSection{},
            lower_section: %LowerSection{}

  @upper_section_fields [
    :ones,
    :twos,
    :threes,
    :fours,
    :fives,
    :sixes
  ]
  @lower_section_fields [
    :three_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :small_straight,
    :large_straight,
    :yahtzee,
    :change
  ]

  def new(), do: %Scorecard{}

  def sum(section) do
    section
    |> Map.from_struct()
    |> Map.values()
    |> Enum.sum()
  end

  def update(scorecard, category, value) do
    section_key = get_section(category)
    {:ok, section} = Map.fetch(scorecard, section_key)
    updated_section = section |> Map.put(category, value)

    Map.put(scorecard, section_key, updated_section)
  end

  def get_section(category) do
    if Enum.member?(@upper_section_fields, category) do
      :upper_section
    else
      :lower_section
    end
  end
end
