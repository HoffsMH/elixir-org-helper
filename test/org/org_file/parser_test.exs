defmodule Org.OrgFile.ParserTest do
  use ExUnit.Case
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
end
