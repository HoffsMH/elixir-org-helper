defmodule Org.FileTest do
  use ExUnit.Case
  alias Org.File
  alias FS.IOMap

  test "prepend/2" do
    with args <- ["prefix-", "~/some/file/name.exs"],
         io_map <- %IOMap{} do
      IO.inspect(Org.File.prepend(io_map, args))
    end
  end
end
