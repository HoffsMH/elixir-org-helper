defmodule Org.CapTest do
  use ExUnit.Case

  @files_map %{
    capture_file: %{
      type: :file,
      content: "* some already existing heading\n* some other heading",
      name: "hi"
    }
  }

  @io_map %FS.IOMap{files: @files_map}

  @args [
    "some data to capture"
  ]

  test "It outputs a contents map" do
    with result <- Org.Cap.run(@io_map, @args),
         expected <-
           String.trim(~S"""
           * some already existing heading
           * some other heading
           * some data to capture
           """) do
      assert(
        Enum.any?(get_file_writes(result), &(&1 === :capture_file)),
        "capure_file is now listed in the suggested write actions"
      )

      assert(
        Map.from_struct(result)[:files][:capture_file][:content] === expected,
        "file contents has the data"
      )
    end
  end

  def get_file_writes(io) do
    Map.get(Map.get(io, :actions), :write)
  end
end
