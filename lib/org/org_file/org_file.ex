defmodule Org.OrgFile do
  defdelegate parse(content), to: Parser
end
