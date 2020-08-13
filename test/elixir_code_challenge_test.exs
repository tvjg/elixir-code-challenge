defmodule ElixirCodeChallengeTest do
  use ExUnit.Case
  doctest ElixirCodeChallenge

  test "greets the world" do
    assert ElixirCodeChallenge.hello() == :world
  end
end
