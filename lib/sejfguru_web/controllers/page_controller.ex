defmodule SejfguruWeb.PageController do
  use SejfguruWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def protected(conn, _params) do
    conn
    |> assign(:assets, [%{id: 1, name: 'Samsung Galaxy S8', location: 'Poznan' }]) # TODO: Put real assets here
    |> render("protected.html")
  end
end
