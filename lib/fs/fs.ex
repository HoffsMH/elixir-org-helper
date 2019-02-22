defmodule FS do
  @doc """
  will take a map(entity_map) of
  entity labels as keys
  and entity names as values

  an entity is either a file name a link name or a directory name

  it will return a map of labels and either file contents
  or directory listing


  labels are generic
  like "project_list"

  we need some way of identifying the final file?
  input
  entity_map
  %{
    entity_key entity_value
    project_list: "~/personal/01-schedule/project-list.org"
  }


  output
  contents_map that is generated
  %{
    content_entry in content_map
    content_key
    content_map
    project_dir %{
    type: "dir"
    name: "~/personal/01-schedule/project-list.org",
    content: "adfasdfaasdfasdfafasd\nasdfassfassdfa\nasdfasdfanssdf\n"
    }
  }

  two different activities/domains
  creating and updating io maps
  (updating data structure)

  applying io maps to the file system
  (using data-structure to take action on)


  """

  def apply_io(io_map) do
    apply_writes(io_map)
  end

  def apply_writes(io_map) do
    get_in(io_map.actions, :write)
    |> Enum.each(&apply_write(&1, io_map))
  end

  def apply_write(file_label, io_map) do
    get_in(io_map.files, file_label)
    |> write()
  end

  def write(file_entry) do
    Map.get(file_entry, :name)
    |> File.write!(Map.get(file_entry, :content))
  end
end
