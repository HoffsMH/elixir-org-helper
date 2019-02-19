defmodule Org.OrgFile.HeadingSorterTest do
  use ExUnit.Case

  alias Org.OrgFile.HeadingSorter
  alias Org.OrgFile.Heading

  @heading_one [
    %Heading{value: "Hello"}
  ]

  @heading_two [
    %Heading{value: "goodbye"}
  ]

  test "sort/2 2 simple list no crossover" do
    with list_one <- [%Heading{value: "hello"}],
         list_two <- [%Heading{value: "goodbye"}],
         result <- HeadingSorter.sort(list_one, list_two) do
      assert is_map(result)
      assert Map.get(result, :list_one_only) === list_one
      assert Map.get(result, :list_two_only) === list_two
    end
  end

  test "sort/2 2 simple list some crossover" do
    with common_heading_one <- %Heading{value: "common", content: ["content1"]},
         common_heading_two <- %Heading{value: "common", content: ["content2"]},
         list_one <- [
           %Heading{value: "hello"},
           common_heading_one
         ],
         list_two <- [
           %Heading{value: "goodbye"},
           common_heading_two
         ],
         result <- HeadingSorter.sort(list_one, list_two) do
      assert is_map(result)
      assert Map.get(Enum.at(Map.get(result, :merged), 0), :value) === "common"
      assert Map.get(Enum.at(Map.get(result, :merged), 0), :content) === ["content1", "content2"]
    end
  end
end
