defmodule Org.ProjectListGroomer do
  # def run(contents_map, sorted_headings) when is_map(sorted) do
  #   matched_header = "* ---Matched---"

  #   matched_output =
  #     Map.get(sorted, :merged)
  #     |> Enum.reduce(matched_header, &(&2 <> Writer.write(&1)))

  #   new_header = "\n* ---New---"

  #   new_output =
  #     Map.get(sorted, :list_one_only)
  #     |> Enum.reduce(new_header, &(&2 <> Writer.write(&1)))

  #   orphaned_header = "\n* ---Orphaned---"

  #   orphaned_output =
  #     Map.get(sorted, :list_two_only)
  #     |> Enum.reduce(orphaned_header, &(&2 <> Writer.write(&1)))

  #   complete_output = matched_output <> new_output <> orphaned_output

  #   new_content_map =
  #     Map.get(contents_map, :project_list_file)
  #     |> Map.put(:content, complete_output)

  #   Map.put(contents_map, :project_list_file, new_content_map)
  # end

  # def run(sorted, project_list_filename) when is_map(sorted) do
  #   File.write(Path.expand(project_list_filename), run(sorted))
  # end

  # def run(project_list_filename, projects_directory_name, :test)
  #     when is_binary(project_list_filename) and is_binary(projects_directory_name) do
  #   with active_projects_list <- project_list_as_headings(projects_directory_name),
  #        current_project_list_headings <- Parser.parse(project_list_filename) do
  #     run(Sorter.sort(active_projects_list, current_project_list_headings), :test)
  #   end
  # end

  # def run(project_list_filename, projects_directory_name)
  #     when is_binary(project_list_filename) and is_binary(projects_directory_name) do
  #   with active_projects_list <- project_list_as_headings(projects_directory_name),
  #        current_project_list_headings <- Parser.parse(project_list_filename) do
  #     run(
  #       Sorter.sort(active_projects_list, current_project_list_headings),
  #       project_list_filename
  #     )
  #   end
  # end

  def project_list_as_headings(contents_map) do
    contents_map
    |> Map.get(:project_support_dir)
    |> Map.get(:content)
    |> Enum.reject(&(&1 === ".stfolder"))
    |> Enum.reject(&(&1 === ".stignore"))
    |> Enum.reject(&(&1 === ".stversions"))
    |> Enum.reject(&(&1 === ".DS_Store"))
    |> Enum.map(&%Org.OrgFile.Heading{value: &1})
  end
end
