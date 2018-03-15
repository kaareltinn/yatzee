defmodule YatzeeTest do
  use ExUnit.Case
  doctest Yatzee

  test "new_game() returns new game" do
    game = Yatzee.new_game(["Frank"])

    assert %{
             players: %{
               "Frank" => %{name: "Frank", scorecard: %Yatzee.Scorecard{}, turns_left: 13}
             }
           } = game
  end
end
