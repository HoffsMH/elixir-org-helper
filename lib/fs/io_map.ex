defmodule FS.IOMap do
  @empty_actions %{
    create: [],
    delete: [],
    rename: [],
    write: []
  }

  defstruct actions: @empty_actions,
            files: %{}

  def gen_new(args) do
    %FS.IOMap{files: gen_files_map(args)}
  end

  def gen_files_map(args) do
    args
    |> Enum.reduce(%{}, &add_file_entry(&2, &1))
  end

  def add_file_entry(files_map, {key, value}) do
    Map.put(files_map, key, gen_file_entry(value))
  end

  def gen_file_entry(value) do
    with full_name <- Path.expand(value) do
      if File.regular?(full_name) do
        %{
          type: :file,
          name: full_name,
          content: File.read!(full_name)
        }
      else
        %{
          type: :dir,
          name: full_name,
          content: File.ls!(full_name)
        }
      end
    end
  end

  def update_file_entry(io_map, entry_label, entry_value) do
    with files_map <- Map.get(io_map, :files),
         new_files_map <- Map.put(files_map, entry_label, entry_value) do
      Map.put(io_map, :files, new_files_map)
    end
  end

  def update_file_content(io_map, entry_label, entry_content) do
    with old_entry <- get_file_entry(io_map, entry_label),
         new_entry <- %{
           old_entry
           | content: entry_content
         } do
      update_file_entry(io_map, entry_label, new_entry)
    end
  end

  def get_file_entry(io_map, entry_label) do
    get_in(Map.from_struct(io_map), [:files, entry_label])
  end

  def get_action_list(io_map, action_label) do
    get_in(Map.from_struct(io_map), [:actions, action_label])
  end

  def get_file_content(io_map, entry_label) do
    Map.get(get_file_entry(io_map, entry_label), :content)
  end

  def add_to_actions(io_map, action_type, action) do
    with action_map <- Map.get(io_map, :actions),
         action_type_list <- Map.get(action_map, action_type),
         new_action_type_list <- [action | action_type_list],
         new_action_map <- Map.put(action_map, action_type, new_action_type_list) do
      Map.put(io_map, :actions, new_action_map)
    end
  end

  def add_to_write_actions(io_map, action) do
    add_to_actions(io_map, :write, action)
  end
end
