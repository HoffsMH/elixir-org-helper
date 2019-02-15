defmodule Org do
  @moduledoc """
  This thing doesn't know about CLI arguments

  Inputs recognized SO FAR

  Filename for project-list
  directory name for projects

  Capture items
  strings for appending to file names
  """

  alias Org.ProjectListGroomer
  @default_root_dir "~/personal"

  @defaults %{
    project_list_file: "#{@default_root_dir}/01-schedule/project-list.org",
    project_support_dir: "#{@default_root_dir}/02-project-support",
    capture_file: "#{@default_root_dir}/00-capture/capture.org"
  }
  def defaults, do: @defaults

  def default_tasks do
    ProjectListGroomer.groom()
  end

  def file([operation | args]) do
    case operation do
      "prepend" -> Org.File.prepend(args)
      "trim" -> Org.File.trim(args)
    end
  end

  defdelegate cap(content), to: Org.Cap
end
