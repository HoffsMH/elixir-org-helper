defmodule Org.ProjectListGroomerTest do
  use ExUnit.Case
  alias Org.ProjectListGroomer

  @default_project_list [
    "a",
    "b",
    ".stfolder",
    ".stignore",
    ".stversions",
    ".DS_Store"
  ]

  def gen_contents_map(list \\ @default_project_list) do
    %{
      project_support_dir: %{
        content: list
      }
    }
  end

  test "get_active_projects_list_as_headings/1" do
    import ProjectListGroomer

    with contents_map <- gen_contents_map(),
         result <- project_list_as_headings(contents_map),
         expected <- [
           %Org.Heading{value: "a"},
           %Org.Heading{value: "b"}
         ] do
      assert(
        Enum.sort(result) === Enum.sort(expected),
        "correctly ignores the entries that are not projects"
      )
    end
  end
end
