defmodule FS_test do
  use ExUnit.Case

  @expected_file_contents """
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

  @expected_dir_contents [
    "dir1",
    "dir2",
    "dir3",
    ".stversions",
    ".stfolder"
  ]

  @default_file_opts %{
    file_key_one: "/normal_org_file.org",
    file_key_two: "/normal_dir"
  }

  test "add_file/2 with a normal org file" do
    with result <- FS.add_file(%FS.IOMap{}, {:my_file_key, "/normal_org_file.org"}),
         expected <- %FS.IOMap{
           files: %{
             my_file_key: %{
               content: @expected_file_contents,
               name: "/normal_org_file.org",
               type: :file
             }
           }
         } do
      assert result === expected
    end
  end

  test "add_file/2 with a normal directory" do
    with result <- FS.add_file(%FS.IOMap{}, {:my_file_key, "/normal_dir"}),
         expected <- %FS.IOMap{
           files: %{
             my_file_key: %{
               content: @expected_dir_contents,
               name: "/normal_dir",
               type: :dir
             }
           }
         } do
      assert result === expected
    end
  end

  test "add_files/2 with normal file and normal directory" do
    with result <- FS.add_files(%FS.IOMap{}, @default_file_opts),
         expected <- %FS.IOMap{
           actions: %FS.IOMap.Actions{create: [], delete: [], rename: [], write: []},
           files: %{
             file_key_one: %{
               content: @expected_file_contents,
               name: "/normal_org_file.org",
               type: :file
             },
             file_key_two: %{
               content: @expected_dir_contents,
               name: "/normal_dir",
               type: :dir
             }
           }
         } do
      assert result === expected
    end
  end
end
