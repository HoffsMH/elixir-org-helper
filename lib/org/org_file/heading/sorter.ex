defmodule Org.Heading.Sorter do
  alias Org.Heading.Merger

  defstruct merged: [],
            list_one_only: [],
            list_two_only: []

  def sort(heading_list_one, heading_list_two) do
    sort(heading_list_one, heading_list_two, %Org.Heading.Sorter{})
  end

  def sort([], [], sorted_headings), do: sorted_headings

  def sort(heading_list_one, [], sorted_headings) do
    sort([], [], sort_heading(sorted_headings, :list_one_only, heading_list_one))
  end

  def sort([], heading_list_two, sorted_headings) do
    sort([], [], sort_heading(sorted_headings, :list_two_only, heading_list_two))
  end

  def sort(heading_list_one, [heading | heading_list_two], sorted_headings) do
    with matched <- filter_value_matches(heading_list_one, heading),
         merged <- Merger.merge(matched, heading),
         type <- get_type(matched) do
      sort(
        reject_value_matches(heading_list_one, heading),
        heading_list_two,
        sort_heading(sorted_headings, type, merged)
      )
    end
  end

  defp get_type([]), do: :list_two_only

  defp get_type(_), do: :merged

  defp sort_heading(sorted_headings, category, list_of_headings_to_add) do
    with headings <- Map.get(sorted_headings, category),
         new_headings <- headings ++ list_of_headings_to_add do
      Map.put(sorted_headings, category, new_headings)
    end
  end

  def filter_value_matches(heading_list, heading) do
    heading_list
    |> Enum.filter(&Matcher.value_match?(&1, heading))
  end

  def reject_value_matches(heading_list, heading) do
    heading_list
    |> Enum.reject(&Matcher.value_match?(&1, heading))
  end
end
