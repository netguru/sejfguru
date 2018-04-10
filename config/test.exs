use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sejfguru, SejfguruWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sejfguru, Sejfguru.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sejfguru",
  password: "",
  database: "sejfguru_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :sejfguru, SejfguruWeb.Endpoint,
  secret_key_base: "ODECxurJvM4ht8w6YXiC+2tLkR88DFAwi+WU6kUsZd/yTrnfSeLFccJFfRYnjxu5"

config :sejfguru, SejfguruWeb.Guardian,
  secret_key: "g9msHDfRDkTU0j8jI8ToBNpk4rMk7+5DmjXsSPoLzHups/A25PYvQZLhZ/lgg16D"

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [
         request_path: "/auth",
         callback_path: "/auth-callback",
         default_scope: "email",
         hd: "example.com"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "test_client_id",
  client_secret: "test_client_secret"
