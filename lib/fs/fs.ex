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

  def update_contents_map(io, content_map_label, new_content_map) do
    with contents_map <- Map.get(io, :contents_map),
         new_contents_map <- Map.put(contents_map, content_map_label, new_content_map) do
      Map.put(io, :contents_map, new_contents_map)
    end
  end

  def add_to_actions(io, action_type, action) do
    with action_map <- Map.get(io, :action_map),
         action_type_list <- Map.get(action_map, action_type),
         new_action_type_list <- [action | action_type_list],
         new_action_map <- Map.put(action_map, action_type, new_action_type_list) do
      Map.put(io, :action_map, new_action_map)
    end
  end

  def add_to_write_actions(io, action) do
    add_to_actions(io, :write, action)
  end
end
