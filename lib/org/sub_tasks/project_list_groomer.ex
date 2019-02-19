defmodule Org.ProjectListGroomer do
  alias Org.OrgFile.Parser
  alias Org.OrgFile.HeadingSorter
  alias Org.OrgFile.Heading

  def run(io_map) do
    with sorted_headings <-
           HeadingSorter.sort(
             project_list_as_headings(io_map),
             project_list_file_headings(io_map)
           ) do
      run(io_map, sorted_headings)
    end
  end

  def get_project_list_file_content(io_map) do
    get_in(Map.from_struct(io_map), [:files, :project_list_file, :content])
  end

  def project_list_file_headings(io_map) do
    io_map
    |> get_project_list_file_content()
    |> Parser.parse()
  end

  def run(io_map, sorted_headings) when is_map(sorted_headings) do
    matched_header = "* ---Matched---"

    matched_output =
      Map.get(sorted_headings, :merged)
      |> Enum.reduce(matched_header, &(&2 <> Heading.to_string(&1)))

    new_header = "\n* ---New---"

    new_output =
      Map.get(sorted_headings, :list_one_only)
      |> Enum.reduce(new_header, &(&2 <> Heading.to_string(&1)))

    orphaned_header = "\n* ---Orphaned---"

    orphaned_output =
      Map.get(sorted_headings, :list_two_only)
      |> Enum.reduce(orphaned_header, &(&2 <> Heading.to_string(&1)))

    complete_output = matched_output <> new_output <> orphaned_output

    FS.IOMap.update_file_content(io_map, :project_list_file, complete_output)
    |> FS.IOMap.add_to_actions(:write, :project_list_file)
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
