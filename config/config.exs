# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :metrics_demo,
  ecto_repos: [MetricsDemo.Repo]

# Configures the endpoint
config :metrics_demo, MetricsDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e0wEz6PaY5pMsS5QmE8NyZA7gevOBkTvD/ZA/4Re3ZWooRoHNS5uEMKKxV0jvxRr",
  render_errors: [view: MetricsDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MetricsDemo.PubSub,
  live_view: [signing_salt: "mmPfvhb7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
