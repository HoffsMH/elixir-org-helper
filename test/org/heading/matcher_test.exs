defmodule Org.Heading.Matcher.Test do
  use ExUnit.Case
  alias Org.Heading.Matcher

  # it accepts a heading list, and a list of headings
  # it returns a map of matched new and orphaned headings

  test "when given two empty lists" do
    assert Matcher.match([], []) === %{matched: [], new: [], orphaned: []}
  end

  test "when given an empty heading list and a single " do
    assert Matcher.match([], []) === %{matched: [], new: [], orphaned: []}
  end
end
