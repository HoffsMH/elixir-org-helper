defmodule Org.CLI.PhaseTwo do
  # phase 2 inputs
  # List of projects in project directory
  # List of headings in project list
  # a single heading will be a data structure of the form %{content: string, value: string }

  # phase 2 outputs
  # Map of matched, New, and Orphaned headings

  # go through every heading
  # for every heading that you find corresponds to a project folder
  # categorize that heading as a matched heading and remove the project from the project list

  # for every heading that you find that does not have a cooresponding project folder
  # categorize that heading as an orphaned heading

  # at the end of the process if any projects still exist in the project list
  # categorize that heading as an orphaned heading

  def run(project_list, headings) do
    run(project_list, headings, %{matched: [], new: [], orphaned: []})
  end

  def run([], [], sorted_headings) do
    # we are out of projects and headings to be sorted. return the result
    sorted_headings
  end

  def run(project_list, [], sorted_headings) do
    # we are out of headings, we need to empty out the project list into new headings
    run([], [], %{sorted_headings | new: Map.get(sorted_headings, :new) ++ project_list})
  end

  def run([], headings, sorted_headings) do
    # we are out of projects, all unsorted headings MUST be Orphaned
    run([], [], %{sorted_headings | orphaned: Map.get(sorted_headings, :orphaned) ++ headings})
  end

  def run(project_list, headings, sorted_headings) do
    with project <- trim_heading(hd(headings)) do
      if Enum.member?(project_list, project) do
        run(project_list -- [project], tl(headings), %{
          sorted_headings
          | matched: [hd(headings) | Map.get(sorted_headings, :matched)]
        })
      else
        run(project_list, tl(headings), %{
          sorted_headings
          | orphaned: [hd(headings) | Map.get(sorted_headings, :orphaned)]
        })
      end
    end
  end

  def trim_heading(heading) do
    heading
    |> Map.get(:value)
    |> String.replace_prefix("* ", "")
    |> String.replace_suffix("\n", "")
  end
end
