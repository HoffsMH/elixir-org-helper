defmodule Org.FileTest do
  use ExUnit.Case
  alias Org.File
  alias FS.IOMap

  test "prepend/2" do
    with args <- ["prefix-", "/some/file/name.exs"],
         io_map <- %IOMap{},
         resulting_io_map <- Org.File.prepend(io_map, args),
         renames <- get_in(Map.from_struct(resulting_io_map), [:actions, :rename]),
         source <- elem(Enum.at(renames, 0), 0),
         destination <- elem(Enum.at(renames, 0), 1) do
      assert source === "/some/file/name.exs"
      assert destination === "/some/file/prefix-name.exs"
    end
  end
end
