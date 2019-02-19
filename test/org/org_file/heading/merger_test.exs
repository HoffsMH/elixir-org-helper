defmodule Org.OrgFile.Heading.MergerTest do
  use ExUnit.Case
  alias Org.OrgFile.Heading.Merger
  alias Org.OrgFile.Heading

  test "merge/2" do
    with heading_one <- %Heading{value: "hi", content: ["content1"]},
         heading_two <- %Heading{value: "hi", content: ["content2"]},
         result <- Merger.merge(heading_one, heading_two) do
      assert Map.get(result, :value) === "hi"
      assert Map.get(result, :content) === ["content1", "content2"]
    end
  end
end
