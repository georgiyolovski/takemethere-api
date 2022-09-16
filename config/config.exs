# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :takemethere,
  namespace: TakeMeThere,
  ecto_repos: [TakeMeThere.Repo]

# Configure your database
config :takemethere, TakeMeThere.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: System.get_env("DB_HOST"),
  database: System.get_env("DB_NAME"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configures the endpoint
config :takemethere, TakeMeThereWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TakeMeThereWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TakeMeThere.PubSub,
  live_view: [signing_salt: "vgp1S4yR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
