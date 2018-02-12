defmodule SejfguruWeb.BookingController do
  use SejfguruWeb, :controller

  import Ecto.Query

  alias Sejfguru.Repo
  alias Sejfguru.Bookings.Booking

  def index(conn, %{ "asset_id" => asset_id }) do
    bookings = from(b in Booking, where: b.fs_device_id == ^asset_id, select: b)
      |> Repo.all()
      |> Repo.preload(:user)
    render conn, "index.html", bookings: bookings
  end

  def create(conn, %{ "asset_id" => asset_id }) do
    booking = %Booking{ fs_device_id: asset_id, user_id: conn.assigns[:current_user].id }
    Repo.insert!(booking)
    redirect conn, to: booking_path(conn, :index, asset_id)
  end
end
