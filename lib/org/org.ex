defmodule Org do
  @moduledoc """
  This thing doesn't know about CLI arguments

  Inputs recognized SO FAR

  Filename for project-list
  directory name for projects

  Capture items
  strings for appending to file names
  """

  def default_tasks(io_map) do
    io_map
    |> Org.ProjectListGroomer.run()
  end

  def run(io_map, [first_arg | args]) do
    with new_io_map <- default_tasks(io_map) do
      case first_arg do
        "cap" -> Org.Cap.run(io_map, args)
        "file" -> Org.File.run(io_map, args)
      end
    end
  end
end
