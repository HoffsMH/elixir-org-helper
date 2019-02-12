defmodule Org.File do
  @moduledoc """
  This deals with shuffling around files
  """

  def prepend(args) when is_list(args),
    do: prepend(Enum.at(args, 0), Enum.drop(args, 1))

  def prepend(_, []), do: nil

  def prepend(text, [relative_path | rest]) do
    with path <- File.cwd!(),
         dirname <- Path.dirname(relative_path),
         basename <- Path.basename(relative_path),
         source <- Path.expand(relative_path, path),
         destination <- Path.expand("#{dirname}/#{text}#{basename}", path) do
      File.rename(source, destination)
      prepend(text, rest)
    end
  end

  def trim(args) when is_list(args),
    do: trim(Enum.at(args, 0), Enum.drop(args, 1))

  def trim(_, []), do: nil

  def trim(text, [relative_path | rest]) do
    with path <- File.cwd!(),
         dirname <- Path.dirname(relative_path),
         basename <- Path.basename(relative_path),
         source <- Path.expand(relative_path, path),
         destination <- Path.expand("#{dirname}/#{String.trim(basename, text)}", path) do
      File.rename(source, destination)
      trim(text, rest)
    end
  end
end
