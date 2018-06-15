defmodule SejfguruWeb.AssetController do
  use SejfguruWeb, :controller
  require Ecto.Query

  def index(conn, params) do
    conn
    |> assign(:page, fetch_page(params))
    |> assign(:assets, fetch_assets(fetch_page(params)))
    |> render("index.html")
  end

  defp fetch_page(%{"page" => page}), do: String.to_integer(page)
  defp fetch_page(_params), do: 1

  defp fetch_assets(page) do
    Sejfguru.Assets.list_assets_with_users(page: page)
  end
end
