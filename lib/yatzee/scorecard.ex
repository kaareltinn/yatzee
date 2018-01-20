defmodule Yatzee.Scorecard do
  alias Yatzee.Scorecard.{UpperSection, LowerSection}

  defstruct upper_section: %UpperSection{},
            lower_section: %LowerSection{}
end
