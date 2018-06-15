defmodule SejfguruWeb.BookingController do
  use SejfguruWeb, :controller

  alias Sejfguru.Repo
  alias Sejfguru.Bookings
  alias Sejfguru.Bookings.Booking

  def index(conn, %{ "asset_id" => asset_id }) do
    asset = Sejfguru.Assets.get_asset!(String.to_integer(asset_id))
      |> Repo.preload([bookings: :user])
    render conn, "index.html", bookings: asset.bookings
  end

  def create(conn, %{ "asset_id" => asset_id }) do
    booking = %Booking{ asset_id: String.to_integer(asset_id), user_id: conn.assigns[:current_user].id }
    Repo.insert!(booking)
    redirect conn, to: booking_path(conn, :index, asset_id)
  end

  def my_booking(conn, %{}) do
    conn
    |> assign(:my_bookings, Bookings.list_bookings_for_user(conn.assigns[:current_user]))
    |> render("my_booking.html")
  end
end
