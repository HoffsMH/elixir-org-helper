defmodule Org.Cap do
  def cap(content) do
    with capture_filename <- Map.get(Org.defaults(), :capture_file) do
      cap(capture_filename, content)
    end
  end

  def cap(capture_filename, content) do
    with capture_file <- File.open!(Path.expand(capture_filename), [:append]) do
      IO.write(capture_file, "* #{content}\n")
      File.close(capture_file)
    end
  end
end
