# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :shopbird,
  ecto_repos: [Shopbird.Repo]

# Configures the endpoint
config :shopbird, Shopbird.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6JKWw5jmCxzijccS76VT2/TSafwkVMABK2xY2gCmbAtkVmGkqORE1j6GY5p+eCSt",
  render_errors: [view: Shopbird.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Shopbird.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
