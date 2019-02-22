defmodule Org.FileTest do
  use ExUnit.Case
  alias FS.IOMap

  test "prepend/2 with a single file" do
    with args <- ["prefix-", "/some/file/name.exs"],
         resulting_io_map <- Org.File.prepend(%IOMap{}, args),
         renames <- resulting_io_map.actions.rename,
         {source, destination} <- Enum.at(renames, 0) do
      assert source === "/some/file/name.exs"
      assert destination === "/some/file/prefix-name.exs"
    end
  end

  test "prepend/2 with multiple files" do
    with args <- ["prefix-", "/some/file/name.exs", "/some/file/name\ other"],
         resulting_io_map <- Org.File.prepend(%IOMap{}, args),
         renames <- resulting_io_map.actions.rename,
         {source_one, destination_one} <- Enum.at(renames, 1),
         {source_two, destination_two} <- Enum.at(renames, 2) do
      assert source_one === "/some/file/name.exs"
      assert destination_one === "/some/file/prefix-name.exs"

      assert source_two === "/some/file/name other"
      assert destination_two === "/some/file/prefix-name other"
    end
  end

  test "trim/2 with a single file" do
    with args <- ["pref", "/some/file/prefix-name.exs"],
         resulting_io_map <- Org.File.trim(%IOMap{}, args),
         renames <- resulting_io_map.actions.rename,
         {source, destination} <- Enum.at(renames, 0) do
      assert source === "/some/file/prefix-name.exs"
      assert destination === "/some/file/ix-name.exs"
    end
  end

  test "trim/2 with multiple files" do
    with args <- ["pref", "/some/file/prefix-name.exs", "/some/file/prefix-name\ other"],
         resulting_io_map <- Org.File.trim(%IOMap{}, args),
         renames <- resulting_io_map.actions.rename,
         [{source_two, destination_two}, {source_one, destination_one}] <-
           resulting_io_map.actions.rename do
      assert source_one === "/some/file/prefix-name.exs"
      assert destination_one === "/some/file/ix-name.exs"

      assert source_two === "/some/file/prefix-name other"
      assert destination_two === "/some/file/ix-name other"
    end
  end
end
