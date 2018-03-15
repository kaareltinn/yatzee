defmodule Yatzee.ScorecardTest do
  use ExUnit.Case

  alias Yatzee.Scorecard
  alias Yatzee.Scorecard.LowerSection

  test "update() returns scorecard with updated category" do
    updated_scorecard = Scorecard.new()
                        |> Scorecard.update(:three_of_a_kind, 15)

    assert %Scorecard{lower_section: %LowerSection{three_of_a_kind: 15}} = updated_scorecard
  end
end
