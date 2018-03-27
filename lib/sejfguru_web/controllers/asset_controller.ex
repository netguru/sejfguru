defmodule SejfguruWeb.AssetController do
  use SejfguruWeb, :controller

  def index(conn, params) do
    conn
    |> assign(:page, fetch_page(params))
    |> assign(:assets, fetch_assets(1))
    |> render("index.html")
  end

  defp fetch_page(%{"page" => page}), do: String.to_integer(page)
  defp fetch_page(_params), do: 1

  defp fetch_assets(page) do
    case FreshService.Asset.all(page) do
      {:ok, assets } ->
        assets
      _ ->
        []
    end
  end
end
