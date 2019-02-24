use Mix.Config

config :org, File, File

# You can also configure a 3rd-party app:
#
#     config :logger, level: :info

import_config "#{Mix.env()}.exs"
