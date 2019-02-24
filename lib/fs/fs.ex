defmodule FS do
  @doc """


  """
  @file_module Application.get_env(:org, File)

  def file_info(relative_path) do
    with full_name <- Path.expand(relative_path) do
      {
        full_name,
        Path.dirname(full_name),
        Path.basename(full_name)
      }
    end
  end

  def get_file(io_map, label) do
    get_in(io_map.files, [label, :content])
  end

  def append_to_file(io_map, label, content) do
    with new_file_map <-
           update_in(
             io_map.files,
             [label, :content],
             &(&1 <> content)
           ) do
      put_in(io_map.files, new_file_map)
      |> add_to_write_actions(label)
    end
  end

  def add_to_write_actions(io_map, action) do
    update_in(io_map.actions.write, &Enum.uniq([action | &1]))
  end

  def add_to_rename_actions(io_map, action) do
    update_in(io_map.actions.rename, &Enum.uniq([action | &1]))
  end

  def update_file(io_map, label, content) do
    with new_file_map <- put_in(io_map.files, [label, :content], content) do
      put_in(io_map.files, new_file_map)
      |> add_to_write_actions(label)
    end
  end

  def add_files(io_map, file_opts) do
    file_opts
    |> Enum.reduce(io_map, &add_file(&2, &1))
  end

  def add_file(io_map, {key, value}) do
    with new_files_map <- put_in(io_map.files, [key], gen_file(value)) do
      put_in(io_map.files, new_files_map)
    end
  end

  def gen_file(value) do
    with full_name <- Path.expand(value) do
      if @file_module.regular?(full_name) do
        %{
          type: :file,
          name: full_name,
          content: @file_module.read!(full_name)
        }
      else
        %{
          type: :dir,
          name: full_name,
          content: @file_module.ls!(full_name)
        }
      end
    end
  end

  def apply_io!(io_map) do
    apply_writes(io_map)
  end

  defp apply_writes(io_map) do
    io_map.actions.write
    |> Enum.each(&apply_write(&1, io_map))
  end

  defp apply_write(file_label, io_map) do
    io_map.files[file_label]
    |> write()
  end

  defp write(file_entry) do
    file_entry.name
    |> File.write!(file_entry.content)
  end
end
