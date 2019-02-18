defmodule Org.Heading.List do
  alias Org.Heading.Matcher

  def filter_value_matches(heading_list, heading) do
    heading_list
    |> Enum.filter(&Matcher.value_match?(&1, heading))
  end

  def reject_value_matches(heading_list, heading) do
    heading_list
    |> Enum.reject(&Matcher.value_match?(&1, heading))
  end
end
