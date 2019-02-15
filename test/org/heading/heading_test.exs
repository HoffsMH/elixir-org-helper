defmodule Org.HeadingTest do
  use ExUnit.Case
  alias Org.Heading

  test "it comes with an empty string as the value" do
    assert Map.get(%Heading{}, :value) === ""
  end

  test "it comes with an empty List as the content" do
    assert Map.get(%Heading{}, :content) === []
  end

  test "add_line/2" do
    with heading <- %Heading{},
         result_1 <- Heading.add_line_to_content(heading, "hello"),
         result_2 <- Heading.add_line_to_content(result_1, "goodbye") do
      assert Map.get(result_1, :content) === ["hello"]
      assert Map.get(result_2, :content) === ["goodbye", "hello"]
    end
  end

  test "to_string/1" do
    with heading <- %Heading{value: "* hello", content: ["hello", "world"]},
         result <- Heading.to_string(heading) do
      assert result == "\n* hello\nworld\nhello"
    end
  end
end
