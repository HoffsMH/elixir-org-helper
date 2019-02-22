defmodule FS.IOMap.ActionsTest do
  use ExUnit.Case
  alias FS.IOMap.Actions

  test "add_to_write/2" do
    with initial_actions <- %Actions{},
         resulting_actions <- Actions.add_to_write(initial_actions, :some_file) do
      assert initial_actions.write === []
      assert resulting_actions.write === [:some_file]
      assert resulting_actions.rename === []
    end
  end
end
