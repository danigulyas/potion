# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :potion,
  ecto_repos: [Potion.Repo]

# Configures the endpoint
config :potion, Potion.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DUFF+yx64YawjERgFgNF0l5vQqaKlzk0hwVNTHTv1ixKtUjCvszmFWW+p8i++h+V",
  render_errors: [view: Potion.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Potion.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"