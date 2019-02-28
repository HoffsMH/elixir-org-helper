defmodule TestFile do
  def regular?("file"), do: true

  def regular?("/normal_org_file.org"), do: true
  def regular?("/normal_dir"), do: false
  def regular?(_), do: false

  def read!("/normal_org_file.org") do
    """
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
  end

  def read!(_) do
    "some text"
  end

  def ls!(_) do
    [
      "dir1",
      "dir2",
      "dir3",
      ".stversions",
      ".stfolder"
    ]
  end

  def rename(_, _), do: :noop
  def write!(_, _), do: :noop
end
