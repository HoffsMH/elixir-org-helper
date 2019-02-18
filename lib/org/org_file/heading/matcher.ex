defmodule Org.OrgFile.Heading.Matcher do
  alias Org.OrgFile.Heading

  def value_match?(%{value: value_one}, %{value: value_two}) do
    prep_value_for_comparison(value_one) === prep_value_for_comparison(value_two)
  end

  def complete_match?(heading_one, heading_two) do
    Heading.to_string(heading_one) === Heading.to_string(heading_two)
  end

  def value_only_match?(heading_one, heading_two) do
    value_match?(heading_one, heading_two) && !complete_match?(heading_one, heading_two)
  end

  def prep_value_for_comparison(value) do
    Heading.ensure_formatting(value)
  end
end
