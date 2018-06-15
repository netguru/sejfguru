defmodule SejfguruWeb.BookingController do
  use SejfguruWeb, :controller

  alias Sejfguru.Repo
  alias Sejfguru.Assets
  alias Sejfguru.Assets.Asset
  alias Sejfguru.Bookings
  alias Sejfguru.Bookings.Booking

  def index(conn, %{ "asset_id" => asset_id }) do
    bookings = Sejfguru.Bookings.list_bookings_for_asset(asset_id)
    conn
    |> assign(:bookings, bookings)
    |> render("index.html")
  end

  def create(conn, %{ "asset_id" => asset_id }) do
    asset = Assets.get_asset!(asset_id) |> Repo.preload(:bookings)
    with true <- Asset.is_not_borrowed(asset),
      booking <- %Booking{asset_id: String.to_integer(asset_id), user_id: conn.assigns[:current_user].id},
      {:ok, booking} <- Repo.insert(booking) do
        conn
        |> put_flash(:info, "Asset borrowed")
        |> redirect(to: booking_path(conn, :index, asset_id))
    else
      false ->
        conn
        |> put_flash(:error, "Asset already borrowed")
        |> redirect(to: asset_path(conn, :index))
    end
  end

  def return(conn, %{"id" => booking_id}) do
    booking = Bookings.get_booking!(booking_id) |> Repo.preload(asset: [bookings: :user])
    with true <- Asset.is_borrowed_by_user(booking.asset, conn.assigns[:current_user]),
      {:ok, booking} <- Bookings.update_booking(booking, %{returned_at: DateTime.utc_now()}) do
        conn
        |> put_flash(:info, "Asset returned")
        |> redirect(to: booking_path(conn, :index, booking.asset_id))
    else
      false ->
        conn
        |> put_flash(:error, "Asset cannot be returned by you")
        |> redirect(to: asset_path(conn, :index))
    end
  end

  def my_booking(conn, %{}) do
    conn
    |> assign(:my_bookings, Bookings.list_bookings_for_user(conn.assigns[:current_user]))
    |> render("my_booking.html")
  end
end
