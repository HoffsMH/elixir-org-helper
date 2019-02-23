defmodule Org.ProjectListGroomerTest do
  use ExUnit.Case
  alias Org.ProjectListGroomer
  alias FS.IOMap

  @default_project_list [
    "project a",
    "project b",
    "project c",
    ".stfolder",
    ".stignore",
    ".stversions",
    ".DS_Store"
  ]

  @io_map %IOMap{
    files: %{
      project_list_file: %{
        type: :file,
        name: "project-list/file-name",
        content: """
        * project b
        some sub content 1
        goodbye
        ** project a
        asdf

        * project a
        some sub content 2
        hello

        * This should be orphaned
        some sub content 3
        taco
        """
      },
      project_support_dir: %{
        type: :file,
        name: "project/support/dir",
        content: @default_project_list
      }
    }
  }

  @already_groomed_io_map %IOMap{
    files: %{
      project_list_file: %{
        type: :file,
        name: "project-list/file-name",
        content: """
        * ---Matched---
        * project a
        some sub content 2
        hello

        * project b
        some sub content 1
        goodbye
        ** project a
        asdf

        * ---New---
        * project c
        * ---Orphaned---
        * This should be orphaned
        some sub content 3
        taco
        """
      },
      project_support_dir: %{
        type: :file,
        name: "project/support/dir",
        content: @default_project_list
      }
    }
  }

  test "get_active_projects_list_as_headings/1" do
    import ProjectListGroomer

    with io_map <- @io_map,
         result <- project_list_as_headings(io_map),
         expected <- [
           %Org.OrgFile.Heading{value: "project a"},
           %Org.OrgFile.Heading{value: "project b"},
           %Org.OrgFile.Heading{value: "project c"}
         ] do
      assert(
        Enum.sort(result) === Enum.sort(expected),
        "correctly ignores the entries that are not projects"
      )
    end
  end

  test "run/1" do
    with io_map <- @io_map,
         result <- ProjectListGroomer.run(io_map),
         expected <- """
         * ---Matched---
         * project a
         some sub content 2
         hello

         * project b
         some sub content 1
         goodbye
         ** project a
         asdf

         * ---New---
         * project c
         * ---Orphaned---
         * This should be orphaned
         some sub content 3
         taco
         """ do
      assert(
        FS.get_file(result, :project_list_file) === expected,
        "it is sorted"
      )
    end
  end

  test "run/1 when there are already dividers present" do
    with io_map <- @already_groomed_io_map,
         result <- ProjectListGroomer.run(io_map),
         expected <- """
         * ---Matched---
         * project c
         * project b
         some sub content 1
         goodbye
         ** project a
         asdf

         * project a
         some sub content 2
         hello

         * ---New---
         * ---Orphaned---
         * This should be orphaned
         some sub content 3
         taco
         """ do
      assert(
        FS.get_file(result, :project_list_file) === expected,
        "dividers are not copied and the new project is now in matched"
      )
    end
  end
end
