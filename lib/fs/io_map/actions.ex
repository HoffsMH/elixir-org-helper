defmodule FS.IOMap.Actions do
  defstruct create: [],
            delete: [],
            rename: [],
            write: []

  def add_to_write(action_map, file_label) do
    update_in(action_map.write, &[file_label | &1])
  end
end
