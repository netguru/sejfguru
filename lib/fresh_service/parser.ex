defmodule FreshService.Parser do
  @moduledoc """
  A JSON parser for FreshService API responses.
  """

  @type http_status_code :: number
  @type success :: {:ok, map}
  @type success_list :: {:ok, [map]}
  @type error :: {:error, String.t(), http_status_code}

  @type parsed_response :: success | error
  @type parsed_list_response :: success_list | error

  @doc """
  Parse a response expected to contain a single resource. JSON will be parsed into
  module's `__struct__`.

  ## Examples

  For a module named TestAsset you can parse JSON into a struct like so:

      iex> import FreshService.TestAsset
      iex> alias FreshService.TestAsset
      iex> response = %{body: "{ \\"id\\": \\"123\\" }", status_code: 200}
      iex> FreshService.Parser.parse(response, TestAsset)
      {:ok, %TestAsset{id: "123"}}
  """
  @spec parse(HTTPoison.Response.t(), module) :: success | error
  def parse(response, module) do
    handle_errors(response, fn body ->
      Poison.decode!(body, as: module.__struct__)
    end)
  end

  @doc """
  Parse a response expected to contain multiple resources. JSON will be parsed into
  module's `__struct__`.

  ## Examples

  For a module named TestAsset and JSON in the following format you can parse JSON into a struct like so:
      iex> import FreshService.TestAsset
      iex> alias FreshService.TestAsset
      iex> response = %{body: "[ { \\"id\\": \\"1\\"} , { \\"id\\": \\"2\\" } ]", status_code: 200}
      iex> FreshService.Parser.parse_list(response, TestAsset)
      {:ok, [%TestAsset{id: "1"}, %TestAsset{id: "2"}]}
  """
  @spec parse_list(HTTPoison.Response.t(), module) :: success_list | error
  def parse_list(response, module) do
    handle_errors(response, fn body ->
      Poison.decode!(body, as: [module.__struct__])
    end)
  end

  @spec handle_errors(HTTPoison.Response.t(), (String.t() -> any)) :: success | error
  defp handle_errors(response, fun) do
    case response do
      %{body: body, status_code: status} when status in [200, 201] ->
        try do
          {:ok, fun.(body)}
        rescue
          BadMapError -> format_error(body, status)
        end

      %{body: body, status_code: status} ->
        format_error(body, status)
    end
  end

  defp format_error(body, status) do
    {:ok, json} = Poison.decode(body)
    {:error, json, status}
  end
end
