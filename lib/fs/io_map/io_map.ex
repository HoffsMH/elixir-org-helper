defmodule FS.IOMap do
  alias FS.IOMap.{Actions, Context}

  defstruct actions: %Actions{},
            files: %{}
end
