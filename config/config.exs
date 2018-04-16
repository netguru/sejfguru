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

config :sejfguru, SejfguruWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :sejfguru, Sejfguru.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME"),
  database: System.get_env("DB_NAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: System.get_env("DB_PORT"),
  pool_size: 10

config :sejfguru, SejfguruWeb.Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_BASE")

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [
      request_path: "/auth", callback_path: "/auth-callback", default_scope: "email profile",
      hd: System.get_env("UEBERAUTH_GOOGLE_DOMAIN")
    ]}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("UEBERAUTH_GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("UEBERAUTH_GOOGLE_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
