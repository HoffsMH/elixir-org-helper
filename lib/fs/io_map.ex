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
    if File.regular?(value) do
      %{
        type: :file,
        name: value,
        content: File.read!(value)
      }
    else
      %{
        type: :dir,
        name: value,
        content: File.ls!(value)
      }
    end
  end

  def update_file_entry(io_map, entry_label, entry_value) do
    with files_map <- Map.get(io_map, :files),
         new_files_map <- Map.put(files_map, entry_label, entry_value) do
      Map.put(io_map, :files, new_files_map)
    end
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
