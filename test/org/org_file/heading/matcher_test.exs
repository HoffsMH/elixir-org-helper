defmodule Org.OrgFile.Heading.MatcherTest do
  use ExUnit.Case
  alias Org.OrgFile.Heading.Matcher
  alias Org.OrgFile.Heading

  test "value_match?/2 when the two values match" do
    with heading_one <- %Heading{value: "one"},
         heading_two <- %Heading{value: "one"},
         result <- Matcher.value_match?(heading_one, heading_two) do
      assert(
        result === true,
        "they dont match values"
      )
    end
  end

  test "value_match?/2 when the two values dont match" do
    with heading_one <- %Heading{value: "one"},
         heading_two <- %Heading{value: "two"},
         result <- Matcher.value_match?(heading_one, heading_two) do
      assert(
        result === false,
        "they dont match values"
      )
    end
  end

  test "value_match?/2 when the two values match but the contents do not" do
    with heading_one <- %Heading{value: "one", content: []},
         heading_two <- %Heading{value: "one", content: ["hi"]},
         result <- Matcher.value_match?(heading_one, heading_two) do
      assert(
        result === true,
        "they dont match values"
      )
    end
  end
end
