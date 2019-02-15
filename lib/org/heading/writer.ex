defmodule Org.Heading.Writer do
  alias Org.Heading

  def write(heading) do
    write("", heading)
  end

  def write(output, heading) do
    output <> Heading.to_string(heading)
  end
end
