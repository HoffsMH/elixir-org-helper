defmodule FS.IOMap do
  alias FS.IOMap.Actions

  defstruct actions: %Actions{},
            files: %{}
end
