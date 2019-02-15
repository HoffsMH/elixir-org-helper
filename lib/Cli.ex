defmodule Org.CLI do
  def main(args) do
    if Enum.at(args, 0) === "cap" do
      Org.cap(Enum.at(args, 1))
    end

    if Enum.at(args, 0) === "file" do
      Org.file(Enum.drop(args, 1))
    end

    Org.default_tasks()
  end
end
