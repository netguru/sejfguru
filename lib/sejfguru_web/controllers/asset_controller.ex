defmodule SejfguruWeb.AssetController do
  use SejfguruWeb, :controller
  alias Sejfguru.{Repo, Asset}

  def index(conn, _params) do
    assets = Repo.all(Asset)
    render conn, "index.html", assets: assets
  end
end
