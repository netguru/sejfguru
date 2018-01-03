defmodule SejfguruWeb.PageController do
  use SejfguruWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def protected(conn, _params) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> assign(:assets, [])
    |> render("protected.html")
  end
end
