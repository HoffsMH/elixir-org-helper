defmodule Org.OrgFile.ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Org.OrgFile.Parser

  @org_file_contents """
  * some project
  some text underneath
  ** some subheading
  some other text underneath

  * some other project
  *** what
  ** hi
  """

  property """
  always returns a list,
  There cannot be more headings than there are lines in the file
  """ do
    check all lines <- list_of(string(:printable)),
              file = Enum.join(lines, "\n"),
              result = Parser.parse(file) do
      assert is_list(result)
      assert Enum.all?(result, &(&1.__struct__ == Org.OrgFile.Heading))
      assert length(result) <= length(lines)
    end
  end

  test "parse/1" do
    with result <- Parser.parse(@org_file_contents) do
      assert(
        length(result) === 2,
        "Only 2 top level headings in sample"
      )

      assert(
        Map.get(Enum.at(result, 0), :value) === "* some other project",
        "the last heading is at the top of the list"
      )

      expected_contents = [
        "",
        "** hi",
        "*** what"
      ]

      heading_content = Map.get(Enum.at(result, 0), :content)

      assert(
        heading_content === expected_contents,
        "contents are correct"
      )
    end
  end

  test "parse/1 with an empty file" do
    with result <- Parser.parse("") do
      assert result === [],
        "No Headings found"
    end
  end
end
