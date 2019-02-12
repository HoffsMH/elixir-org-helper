defmodule Org.CLI do
  def main(args) do
    if Enum.at(args, 0) === "cap" do
      Org.cap(Enum.at(args, 1))
    end

    if Enum.at(args, 0) === "file" do
      Org.file(Enum.drop(args, 1))
    end

    if Enum.at(args, 0) === "prepend" do
      Org.prepend(Enum.at(args, 1), Enum.drop(args, 1))
    end

    if Enum.at(args, 0) === "trim" do
      Org.trim(Enum.at(args, 1), Enum.drop(args, 1))
    end

    Org.default_tasks()
  end
end
