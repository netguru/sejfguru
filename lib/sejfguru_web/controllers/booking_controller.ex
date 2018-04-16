defmodule SejfguruWeb.BookingController do
  use SejfguruWeb, :controller

  alias Sejfguru.Repo
  alias Sejfguru.Bookings.Booking

  def index(conn, %{"asset_id" => asset_id}) do
    asset =
      Sejfguru.Assets.get_asset!(String.to_integer(asset_id))
      |> Repo.preload(bookings: :user)

    render(conn, "index.html", bookings: asset.bookings)
  end

  def create(conn, %{"asset_id" => asset_id}) do
    booking = %Booking{
      asset_id: String.to_integer(asset_id),
      user_id: conn.assigns[:current_user].id
    }

    Repo.insert!(booking)
    redirect(conn, to: booking_path(conn, :index, asset_id))
  end
end
