defmodule Org.CLI do
  @moduledoc """
  Receives application arguments and file_and_folder arguments
  turns the file_and_folder arguments into iomaps

  passes application arguments and IOmaps to org
  """

  @default_root_dir "~/personal"

  @default_file_args %{
    project_list_file: "#{@default_root_dir}/01-schedule/project-list.org",
    project_support_dir: "#{@default_root_dir}/02-project-support",
    capture_file: "#{@default_root_dir}/00-capture/capture.org"
  }

  def main(args) do
    with file_args <- gen_file_args(args),
         io_map <- FS.IOMap.gen_new(file_args),
         new_io_map <- Org.run(io_map, args) do
      IO.inspect(new_io_map)

      # FS.apply_contents_map(new_contents_map)
    end
  end

  def gen_file_args(_) do
    @default_file_args
  end
end
