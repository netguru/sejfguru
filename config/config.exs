# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sejfguru,
  ecto_repos: [Sejfguru.Repo]

# Configures the endpoint
config :sejfguru, SejfguruWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SejfguruWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sejfguru.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sejfguru, SejfguruWeb.AuthOptionalPipeline,
  issuer: "sejfguru_app",
  module: SejfguruWeb.Guardian,
  error_handler: SejfguruWeb.AuthErrorHandler

config :sejfguru, SejfguruWeb.AuthRequiredPipeline,
  issuer: "sejfguru_app",
  module: SejfguruWeb.Guardian,
  error_handler: SejfguruWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
