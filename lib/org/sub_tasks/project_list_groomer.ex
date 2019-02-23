defmodule Org.ProjectListGroomer do
  alias Org.OrgFile.Parser
  alias Org.OrgFile.HeadingSorter
  alias Org.OrgFile.Heading

  @matched_divider "* ---Matched---"
  @new_divider "* ---New---"
  @orphaned_divider "* ---Orphaned---"

  def run(io_map) do
    with sorted_headings <-
           HeadingSorter.sort(
             project_list_as_headings(io_map),
             project_list_file_headings(io_map)
           ) do
      run(io_map, sorted_headings)
    end
  end

  def project_list_file_headings(io_map) do
    io_map
    |> FS.get_file(:project_list_file)
    |> Parser.parse()
    |> filter_dividers()
  end

  def filter_dividers(headings) do
    import Heading

    headings
    |> Enum.reject(&(value(&1) === @matched_divider))
    |> Enum.reject(&(value(&1) === @new_divider))
    |> Enum.reject(&(value(&1) === @orphaned_divider))
  end

  def run(io_map, sorted_headings) when is_map(sorted_headings) do
    import Heading

    matched_output =
      Map.get(sorted_headings, :merged)
      |> Enum.reduce(@matched_divider, &(&2 <> Heading.to_string(&1)))

    new_output =
      Map.get(sorted_headings, :list_one_only)
      |> Enum.reduce(ensure_formatting(@new_divider), &(&2 <> Heading.to_string(&1)))

    orphaned_output =
      Map.get(sorted_headings, :list_two_only)
      |> Enum.reduce(ensure_formatting(@orphaned_divider), &(&2 <> Heading.to_string(&1)))

    complete_output = matched_output <> new_output <> orphaned_output

    FS.update_file(io_map, :project_list_file, complete_output)
  end

  def project_list_as_headings(io_map) do
    io_map
    |> Map.get(:files)
    |> Map.get(:project_support_dir)
    |> Map.get(:content)
    |> Enum.reject(&(&1 === ".stfolder"))
    |> Enum.reject(&(&1 === ".stignore"))
    |> Enum.reject(&(&1 === ".stversions"))
    |> Enum.reject(&(&1 === ".DS_Store"))
    |> Enum.map(&%Org.OrgFile.Heading{value: &1})
  end
end
