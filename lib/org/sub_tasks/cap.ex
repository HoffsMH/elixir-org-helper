defmodule Org.Cap do
  alias Org.OrgFile.Heading

  def run(io_map, [arg]) do
    with content <- Heading.ensure_formatting(arg) do
      FS.append_to_file(io_map, :capture_file, content)
    end
  end
end
