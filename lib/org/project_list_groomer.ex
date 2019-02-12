defmodule Org.ProjectListGroomer do
  @moduledoc """
  This accepts a directory for projects
  and
  a filename for a project-list

  It uses these two things to re-groom a project list
  """

  alias Org.HeadingsParser

  def groom(project_list_filename, projects_directory_name) do
    with active_projects_list <- get_active_projects_list(projects_directory_name),
         current_project_list_headings <- HeadingsParser.parse(project_list_filename) do
      Org.CLI.PhaseTwo.run(active_projects_list, current_project_list_headings)
      |> Org.CLI.PhaseThree.run("~/personal/01-schedule/project-list.org")
    end
  end

  def get_active_projects_list(projects_directory_name) do
    Path.expand(projects_directory_name)
    |> File.ls!()
    |> Enum.reject(&(&1 === ".stfolder"))
    |> Enum.reject(&(&1 === ".stignore"))
  end
end
