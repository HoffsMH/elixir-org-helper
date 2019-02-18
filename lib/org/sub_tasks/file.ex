defmodule Org.File do
  @moduledoc """
  This deals with shuffling around files
  """
  alias FS.IOMap

  def run(io_map, [action | args]) do
    case action do
      "prepend" -> prepend(io_map, args)
    end
  end

  def prepend(io_map, args) when is_list(args),
    do: prepend(io_map, Enum.at(args, 0), Enum.drop(args, 1))

  def prepend(io_map, _, []), do: io_map

  def prepend(io_map, text, [relative_path | rest]) do
    with path <- File.cwd!(),
         dirname <- Path.dirname(relative_path),
         basename <- Path.basename(relative_path),
         source <- Path.expand(relative_path, path),
         destination <- Path.expand("#{dirname}/#{text}#{basename}", path),
         new_io_map <- IOMap.add_to_actions(io_map, :rename, {source, destination}) do
      prepend(new_io_map, text, rest)
    end
  end

  def trim(io_map, args) when is_list(args),
    do: trim(io_map, Enum.at(args, 0), Enum.drop(args, 1))

  def trim(io_map, _, []), do: io_map

  def trim(io_map, text, [relative_path | rest]) do
    with path <- File.cwd!(),
         dirname <- Path.dirname(relative_path),
         basename <- Path.basename(relative_path),
         source <- Path.expand(relative_path, path),
         destination <- Path.expand("#{dirname}/#{String.trim(basename, text)}", path),
         new_io_map <- IOMap.add_to_actions(io_map, :rename, {source, destination}) do
      trim(new_io_map, text, rest)
    end
  end
end
