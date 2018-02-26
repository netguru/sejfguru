defmodule FreshService.Config do
  @moduledoc """
  Stores configuration variables used to communicate with FreshService's API.

  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime.
  """

  @doc """
  Returns the FreshService Account username. Set it in `mix.exs`:

      config :fresh_service, username: "YOUR_USERNAME"
  """
  def username, do: from_env(:username)

  @doc """
  Returns the FreshService Account password. Set it in `mix.exs`:

      config :fresh_service, password: "YOUR_PASSWORD"
  """
  def password, do: from_env(:password)

  @doc """
  Returns the FreshService Api key for your account. Set it in `mix.exs`:

      config :fresh_service, api_key: "YOUR_API_KEY"
  """
  def api_key, do: from_env(:api_key)

  @doc """
  Returns the domain of the FreshService. Set it in `mix.exs`:

      config :fresh_service, domain: "YOUR_DOMAIN"
  """
  def domain, do: from_env(:domain)

  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples.
  """
  def from_env(key, default \\ nil)
  def from_env(key, default) do
    Application.get_env(:sejfguru, FreshService)
    |> Keyword.get(key)
    |> read_from_system() || default
  end

  defp read_from_system({:system, env}), do: System.get_env(env)
  defp read_from_system(value), do: value
end
