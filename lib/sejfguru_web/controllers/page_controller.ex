defmodule SejfguruWeb.PageController do
  use SejfguruWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def protected(conn, %{"page" => page}) do
    conn
    |> assign(:page, String.to_integer(page))
    |> assign(:assets, fetch_assets(page))
    |> render("protected.html")
  end

  def protected(conn, _params) do
    conn
    |> assign(:page, 1)
    |> assign(:assets, fetch_assets(1))
    |> render("protected.html")
  end

  defp fetch_assets(page) do
    case FreshService.Asset.all(page) do
      {:ok, assets } ->
        assets
      _ ->
        []
    end
  end
end
