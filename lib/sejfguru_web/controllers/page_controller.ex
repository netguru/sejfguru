defmodule SejfguruWeb.PageController do
  use SejfguruWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
