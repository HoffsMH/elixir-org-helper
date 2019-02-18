defmodule Org.OrgFile.Heading.Merger do
  alias Org.OrgFile.Heading

  def merge([], heading) do
    [heading]
  end

  def merge(heading_list, heading) when is_list(heading_list) do
    heading_list
    |> Enum.map(&merge(&1, heading))
  end

  def merge(%{value: value_one, content: content_one}, %{content: content_two}) do
    %Heading{
      value: value_one,
      content: content_one ++ content_two
    }
  end
end
