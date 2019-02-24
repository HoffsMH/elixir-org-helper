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
end
