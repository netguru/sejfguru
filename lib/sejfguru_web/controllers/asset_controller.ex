defmodule SejfguruWeb.AssetController do
  use SejfguruWeb, :controller
  require Ecto.Query
  alias Sejfguru.Assets.Location

  def index(conn, params) do
    conn
    |> assign(:page, fetch_page(params))
    |> assign(:city_locations, Location.city_lables())
    |> assign(:other_locations, Location.other_labels())
    |> assign(:assets, fetch_assets(fetch_page(params)))
    |> render("index.html")
  end

  defp fetch_page(%{"page" => page}), do: String.to_integer(page)
  defp fetch_page(_params), do: 1

  defp fetch_assets(page) do
    Sejfguru.Assets.list_assets(type: "Mobile", page: page)
  end
end
