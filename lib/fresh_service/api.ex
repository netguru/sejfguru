defmodule FreshService.Api do
  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the FreshService
  API, by wrapping `HTTPotion`.

  ## Examples

  Requests are made to the FreshService API by passing in a resource module into one
  of this `Api` module's functions. The correct URL to the resource is inferred
  from the module name.

      FreshService.Api.find(Asset, "id")
      %Asset{ id: "id", ... }

  Items are returned as instances of the given module's struct. For more
  details, see the documentation for each function.
  """

  use HTTPoison.Base

  alias FreshService.Config
  alias FreshService.Parser
  # alias ExTwilio.UrlGenerator, as: Url
  alias __MODULE__ # Necessary for mocks in tests

  @type data :: map | list

  @doc """
  Find a given resource in the Twilio API by its SID.

  ## Examples

  If the resource was found, `find/2` will return a two-element tuple in this
  format, `{:ok, item}`.

      ExTwilio.Api.find(ExTwilio.Call, "<sid here>")
      {:ok, %Call{ ... }}

  If the resource could not be loaded, `find/2` will return a 3-element tuple
  in this format, `{:error, message, code}`. The `code` is the HTTP status code
  returned by the Twilio API, for example, 404.

      ExTwilio.Api.find(ExTwilio.Call, "nonexistent sid")
      {:error, "The requested resource couldn't be found...", 404}
  """
  @spec find(atom, String.t | nil, list) :: Parser.success | Parser.error
  def find(module, sid, options \\ []) do
    module
    |> Url.build_url(sid, options)
    |> Api.get!(auth_header(options))
    |> Parser.parse(module)
  end

  @spec get(path :: String.t, module :: atom) :: list
  def get(path, module, options \\ []) do
    path
    |> build_url()
    |> Api.get!(auth_header(options))
    |> Parser.parse_list(module)
  end

  @spec get(path :: String.t) :: String.t
  def build_url(path) do
    "https://#{Config.domain}.freshservice.com/#{path}"
  end

  @doc """
  Builds custom auth header for subaccounts

  ## Examples
    iex> ExTwilio.Api.auth_header([account: 123, token: 123])
    ["Authorization": "Basic MTIzOjEyMw=="]

    iex> ExTwilio.Api.auth_header([], {nil, 2})
    []

  """
  @spec auth_header(options :: list) :: list
  def auth_header(options \\ [])  do
    auth_header([], {options[:username], options[:password]})
  end


  @doc """
  Builds custom auth header for subaccounts
  handles master account case if :"Authorization"
  custom header isn't present

  ## Examples

    iex> ExTwilio.Api.auth_header([], {123, 123})
    ["Authorization": "Basic MTIzOjEyMw=="]

    iex> ExTwilio.Api.auth_header(["Authorization": "Basic BASE64=="], {123, 123})
    ["Authorization": "Basic BASE64=="]

  """
  @spec auth_header(headers :: list, auth :: tuple) :: list
  def auth_header(headers, {username, password}) when not is_nil(username) and not is_nil(password) do
    case Keyword.has_key?(headers, :"Authorization") do
      true -> headers
      false ->
        auth = Base.encode64("#{username}:#{password}")
        headers
        |> Keyword.put(:"Authorization", "Basic #{auth}")
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
    |> auth_header({Config.username, Config.password})
  end

  @spec format_data(data) :: binary
  def format_data(data) when is_map(data) do
    data
    |> Map.to_list
    |> Url.to_query_string
  end
  def format_data(data) when is_list(data) do
    Url.to_query_string(data)
  end
  def format_data(data), do: data

end
