defmodule Org.Cap do
  alias FS.IOMap

  def run(io_map, [data]) do
    with capture_file <- get_capture_file(io_map),
         new_capture_file <- update_capture_file(capture_file, data) do
      io_map
      |> IOMap.update_file_entry(:capture_file, new_capture_file)
      |> IOMap.add_to_write_actions(:capture_file)
    end
  end

  def update_capture_file(content_map = %{content: content}, data) do
    %{
      content_map
      | content: content <> "\n* #{data}"
    }
  end

  def get_capture_file(%{files: %{capture_file: capture_file}}) do
    capture_file
  end
end
