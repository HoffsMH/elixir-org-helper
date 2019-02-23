defmodule Org.File do
  @moduledoc """
  This deals with shuffling around files
  """

  def run(io_map, [action | args]) do
    case action do
      "prepend" -> prepend(io_map, args)
      "trim" -> trim(io_map, args)
    end
  end

  def prepend(io_map, args) when is_list(args),
    do: prepend(io_map, Enum.at(args, 0), Enum.drop(args, 1))

  def prepend(io_map, _, []), do: io_map

  def prepend(io_map, text, [relative_path | rest]) do
    with {source, dirname, basename} <- FS.file_info(relative_path),
         destination <- "#{dirname}/#{text}#{basename}",
         new_io_map <- FS.add_to_rename_actions(io_map, {source, destination}) do
      prepend(new_io_map, text, rest)
    end
  end

  def trim(io_map, args) when is_list(args),
    do: trim(io_map, Enum.at(args, 0), Enum.drop(args, 1))

  def trim(io_map, _, []), do: io_map

  def trim(io_map, text, [relative_path | rest]) do
    with {source, dirname, basename} <- FS.file_info(relative_path),
         destination <- "#{dirname}/#{String.trim(basename, text)}",
         new_io_map <- FS.add_to_rename_actions(io_map, {source, destination}) do
      trim(new_io_map, text, rest)
    end
  end
end
