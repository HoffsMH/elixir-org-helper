defmodule Org.Heading do
  defstruct value: "", content: []
  alias Org.Heading

  def add_line(heading = %{content: content}, line) do
    %Heading{heading | content: [line | content]}
  end

  def to_string(%{value: value, content: content}) do
    "\n#{value}#{concat_content(Enum.reverse(content))}"
  end

  def concat_content(content) do
    concat_content(content, "")
  end

  def concat_content([], output), do: output

  def concat_content([heading | headings], output) do
    concat_content(headings, output <> "\n#{heading}")
  end
end
