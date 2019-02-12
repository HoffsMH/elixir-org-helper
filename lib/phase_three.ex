defmodule Org.CLI.PhaseThree do
  alias Org.Heading

  def run(sorted_headings, project_list_filename) do
    run(sorted_headings, project_list_filename, "* ---Matched---")
  end

  def run(sorted_headings = %{matched: []}, filename, output) do
    run(Map.delete(sorted_headings, :matched), filename, output <> "\n* ---New---")
  end

  def run(sorted_headings = %{matched: matched}, filename, output) do
    with new_output <- append_to_output(output, hd(matched)) do
      run(%{sorted_headings | matched: tl(matched)}, filename, new_output)
    end
  end

  def run(sorted_headings = %{new: []}, filename, output) do
    run(Map.delete(sorted_headings, :new), filename, output <> "\n* ---Orphaned---")
  end

  def run(sorted_headings = %{new: new}, filename, output) do
    with new_output <- append_to_output(output, hd(new)) do
      run(%{sorted_headings | new: tl(new)}, filename, new_output)
    end
  end

  def run(%{orphaned: []}, filename, output) do
    File.write(Path.expand(filename), output)
  end

  def run(sorted_headings = %{orphaned: orphaned}, filename, output) do
    with new_output <- append_to_output(output, hd(orphaned)) do
      run(%{sorted_headings | orphaned: tl(orphaned)}, filename, new_output)
    end
  end

  def append_to_output(output, string) when is_binary(string) do
    output <> "\n*" <> string
  end

  def append_to_output(output, heading) do
    output <> Heading.to_string(heading)
  end
end
