defmodule Org do
  @moduledoc """
  This thing doesn't know about CLI arguments

  Inputs recognized SO FAR

  Filename for project-list
  directory name for projects

  Capture items
  strings for appending to file names
  """

  def default_tasks(contents_map) do
    contents_map
    |> Org.ProjectListGroomer.run()
  end

  def run([first_arg | args], io) do
    with new_io <- default_tasks(io) do
      case first_arg do
        "cap" -> Org.Cap.run(io, args)
        "file" -> Org.File.run(io, args)
      end
    end
  end
end
