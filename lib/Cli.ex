defmodule Org.CLI do
  @moduledoc """
  Receives application arguments and file_and_folder arguments
  turns the file_and_folder arguments into iomaps

  passes application arguments and IOmaps to org
  """

  @default_root_dir "~/personal"

  @default_file_opts %{
    project_list_file: "#{@default_root_dir}/01-schedule/project-list.org",
    project_support_dir: "#{@default_root_dir}/02-project-support",
    capture_file: "#{@default_root_dir}/00-capture/capture.org"
  }

  def main(args) do
    with io_map <- FS.add_files(%FS.IOMap{}, @default_file_opts),
         new_io_map <- Org.run(io_map, args) do
      FS.apply_io!(new_io_map)
    end
  end
end
