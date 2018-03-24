defmodule SejfguruWeb.PageController do
  use SejfguruWeb, :controller

  def login(conn, _params) do
    conn
    |> render("login.html")
  end
end
