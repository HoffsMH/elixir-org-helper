defmodule Org.FileTest do
  use ExUnit.Case
  alias Org.File
  alias FS.IOMap

  test "prepend/2 with a single file" do
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

  test "prepend/2 with multiple files" do
    with args <- ["prefix-", "/some/file/name.exs", "/some/file/name\ other"],
         io_map <- %IOMap{},
         resulting_io_map <- Org.File.prepend(io_map, args),
         renames <- get_in(Map.from_struct(resulting_io_map), [:actions, :rename]),
         source_one <- elem(Enum.at(renames, 1), 0),
         destination_one <- elem(Enum.at(renames, 1), 1),
         source_two <- elem(Enum.at(renames, 0), 0),
         destination_two <- elem(Enum.at(renames, 0), 1) do
      assert source_one === "/some/file/name.exs"
      assert destination_one === "/some/file/prefix-name.exs"

      assert source_two === "/some/file/name other"
      assert destination_two === "/some/file/prefix-name other"
    end
  end

  test "trim/2 with a single file" do
    with args <- ["pref", "/some/file/prefix-name.exs"],
         io_map <- %IOMap{},
         resulting_io_map <- Org.File.trim(io_map, args),
         renames <- get_in(Map.from_struct(resulting_io_map), [:actions, :rename]),
         source <- elem(Enum.at(renames, 0), 0),
         destination <- elem(Enum.at(renames, 0), 1) do
      assert source === "/some/file/prefix-name.exs"
      assert destination === "/some/file/ix-name.exs"
    end
  end

  test "trim/2 with multiple files" do
    with args <- ["pref", "/some/file/prefix-name.exs", "/some/file/prefix-name\ other"],
         io_map <- %IOMap{},
         resulting_io_map <- Org.File.trim(io_map, args),
         renames <- get_in(Map.from_struct(resulting_io_map), [:actions, :rename]),
         source_one <- elem(Enum.at(renames, 1), 0),
         destination_one <- elem(Enum.at(renames, 1), 1),
         source_two <- elem(Enum.at(renames, 0), 0),
         destination_two <- elem(Enum.at(renames, 0), 1) do
      assert source_one === "/some/file/prefix-name.exs"
      assert destination_one === "/some/file/ix-name.exs"

      assert source_two === "/some/file/prefix-name other"
      assert destination_two === "/some/file/ix-name other"
    end
  end
end
