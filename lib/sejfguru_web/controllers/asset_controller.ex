defmodule SejfguruWeb.AssetController do
  use SejfguruWeb, :controller
  require Ecto.Query
  alias Sejfguru.Assets.Location

  def index(conn, params) do
    conn
    |> assign(:page, fetch_page(params))
    |> assign(:city_locations, Location.city_lables())
    |> assign(:other_locations, Location.other_labels())
    |> assign(:current_location, fetch_location(params))
    |> assign(:assets, fetch_assets(fetch_page(params), fetch_location(params)))
    |> render("index.html")
  end

  defp fetch_page(%{"page" => page}), do: String.to_integer(page)
  defp fetch_page(_params), do: 1

  # IDEA: Maybe we should geolocate user, and select the nearest city as default option
  defp fetch_location(%{"location" => location}), do: location
  defp fetch_location(_params), do: Location.all_locations_label()

  defp fetch_assets(page, location) do
    Sejfguru.Assets.list_assets_with_users(page: page, location: location)
  end
end
