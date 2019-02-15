defmodule Org.Heading.Matcher do
  defstruct matched: [],
            list_one_only: [],
            list_two_only: []

  def match(heading_list_one, heading_list_two) do
    match(heading_list_one, heading_list_two, %Org.Heading.Matcher{})
  end

  def match([], [], sorted_headings) do
    sorted_headings
  end

  def match(heading_list_one, [], sorted_headings) do
    # there are no more items in list 2
    # put the remaining in list_one_only
    match([], [], add_match_list_one(sorted_headings, heading_list_one))
  end

  def match([], heading_list_two, sorted_headings) do
    # there are no more items in list 1
    # put the remaining in list_two_only
    match([], [], add_match_list_two(sorted_headings, heading_list_two))
  end

  def match(heading_list_one, [heading | heading_list_two], sorted_headings) do
    if member?(heading_list_one, heading) do
      match(
        heading_list_one -- [heading, prep_for_comparison(heading)],
        heading_list_two,
        add_match(sorted_headings, :matched, [heading])
      )
    else
      match(
        heading_list_one,
        heading_list_two,
        add_match_list_two(sorted_headings, [heading])
      )
    end
  end

  defp member?(heading_list, heading) do
    heading_list
    |> Enum.any?(&heading_match?(&1, heading))
  end

  defp heading_match?(heading_one, heading_two) do
    prep_for_comparison(heading_one) === prep_for_comparison(heading_two)
  end

  defp add_match(sorted_headings, category, list_of_headings_to_add) do
    with new_data <- Map.get(sorted_headings, category) ++ list_of_headings_to_add do
      Map.put(sorted_headings, category, new_data)
    end
  end

  defp add_match_list_one(sorted_headings, list_of_headings_to_add) do
    add_match(sorted_headings, :list_one_only, list_of_headings_to_add)
  end

  defp add_match_list_two(sorted_headings, list_of_headings_to_add) do
    add_match(sorted_headings, :list_two_only, list_of_headings_to_add)
  end

  defp prep_for_comparison(%{value: value}) do
    prep_for_comparison(value)
  end

  defp prep_for_comparison(heading) when is_binary(heading) do
    heading
    |> String.replace_prefix("* ", "")
    |> String.replace_suffix("\n", "")
  end
end
