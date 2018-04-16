defmodule FreshService.Api do
  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the FreshService
  API, by wrapping `HTTPotion`.
  """

  use HTTPoison.Base

  alias FreshService.Config
  alias FreshService.Parser
  alias __MODULE__

  @spec get(path :: String.t(), module :: atom) :: list
  def get(path, module, options \\ []) do
    path
    |> build_url()
    |> Api.get!(auth_header(options))
    |> Parser.parse_list(module)
  end

  @spec build_url(path :: String.t()) :: String.t()
  def build_url(path) do
    "https://#{Config.domain()}.freshservice.com/#{path}"
  end

  @doc """
  Builds custom auth header with only username and password given

  ## Examples

    iex> FreshService.Api.auth_header([username: 123, password: 123])
    ["Authorization": "Basic MTIzOjEyMw=="]
  """
  @spec auth_header(options :: list) :: list
  def auth_header(options \\ []) do
    auth_header([], {options[:username], options[:password]})
  end

  @doc """
  Builds custom auth header with headers, username and password
  handles master account case if :"Authorization" custom header isn't present

  ## Examples

    iex> FreshService.Api.auth_header([], {123, 123})
    ["Authorization": "Basic MTIzOjEyMw=="]

    iex> FreshService.Api.auth_header(["Authorization": "Basic BASE64=="], {123, 123})
    ["Authorization": "Basic BASE64=="]
  """
  @spec auth_header(headers :: list, auth :: tuple) :: list
  def auth_header(headers, {username, password})
      when not is_nil(username) and not is_nil(password) do
    if Keyword.has_key?(headers, :Authorization) do
      headers
    else
      auth = Base.encode64("#{username}:#{password}")

      headers
      |> Keyword.put(:Authorization, "Basic #{auth}")
    end
  end

  def auth_header(headers, _), do: headers

  ###
  # HTTPotion API
  ###

  @doc """
  Automatically adds the correct headers to each API request.
  """
  @spec process_request_headers(list) :: list
  def process_request_headers(headers \\ []) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
    |> auth_header({Config.username(), Config.password()})
  end
end
