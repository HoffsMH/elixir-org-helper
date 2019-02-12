defmodule Org.HeadingsParser do
  @toplevelheading ~r/^\* .*$/
  alias Org.Heading
  alias Org.FileState

  def parse(filename) when is_binary(filename) do
    Path.expand(filename)
    |> File.open!([:read])
    |> parse
    |> Enum.reject(&(Map.get(&1, :value) === "* ---New---"))
    |> Enum.reject(&(Map.get(&1, :value) === "* ---Orphaned---"))
    |> Enum.reject(&(Map.get(&1, :value) === "* ---Matched---"))
  end

  def parse(file) do
    parse(file, gen_new_line(file), %FileState{})
  end

  def gen_new_line(file) do
    with line <- next_line_of_file(file) do
      %{line_type: determine_line_type(line), value: line}
    end
  end

  def parse(_, %{line_type: :eof}, file_state) do
    import FileState

    with final_heading <- get_current_heading(file_state),
         headings <- get_headings(file_state),
         final_file_state <- %{
           file_state
           | current_heading: %Heading{},
             headings: [final_heading | headings]
         } do
      get_headings(final_file_state)
    end
  end

  def parse(file, line, file_state) do
    with new_file_state <- gen_new_file_state(file_state, line),
         new_line <- gen_new_line(file) do
      parse(file, new_line, new_file_state)
    end
  end

  def next_line_of_file(file) do
    with line <- IO.read(file, :line) do
      if is_binary(line) do
        String.trim(line)
      else
        line
      end
    end
  end

  def determine_line_type(:eof), do: :eof

  def determine_line_type(line) do
    if Regex.match?(@toplevelheading, line) do
      :toplevelheading
    else
      :subheading
    end
  end

  def gen_new_file_state(file_state = %{headings: headings}, %{
        line_type: :toplevelheading,
        value: line
      }) do
    with previous_heading <- FileState.get_current_heading(file_state) do
      %{
        file_state
        | current_heading: %Heading{value: line},
          headings: [previous_heading | headings]
      }
    end
  end

  def gen_new_file_state(file_state = %{current_heading: current_heading}, %{
        line_type: :subheading,
        value: line
      }) do
    %{file_state | current_heading: Heading.add_line(current_heading, line)}
  end

  def add_subheading([current_heading: current, headings: headings], line) do
    [current_heading: Heading.add_line(current, line), headings: headings]
  end
end
