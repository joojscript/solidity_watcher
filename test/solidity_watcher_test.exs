defmodule SolidityWatcherTest do
  use ExUnit.Case
  doctest SolidityWatcher

  test "greets the world" do
    assert SolidityWatcher.hello() == :world
  end
end
