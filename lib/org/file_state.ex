defmodule Org.FileState do
  alias Org.Heading
  defstruct current_heading: %Heading{}, headings: []

  def get_headings(%{headings: headings}), do: headings
  def get_current_heading(%{current_heading: current}), do: current
end
