defmodule SejfguruWeb.AssetView do
  use SejfguruWeb, :view
  alias Sejfguru.Assets.Asset

  def last_booking(asset) do
    asset.bookings |> Enum.sort_by(fn(x) -> x.id end) |> List.last()
  end

  def last_user(asset) do
    booking = last_booking(asset)
    if booking do
      "#{booking.user.first_name} #{booking.user.last_name}"
    else
      "N/A"
    end
  end

  def last_borrowed_at(asset) do
    booking = last_booking(asset)
    if booking do
      datetime = booking.inserted_at
      "#{datetime.day}/#{datetime.month}/#{datetime.year} #{datetime.hour}:#{datetime.minute}"
    else
      "N/A"
    end
  end

  def asset_status(asset) do
    booking = last_booking(asset)
    if booking && booking.returned_at == nil, do: "borrowed", else: "available"
  end

  def can_return(asset, user) do
    Asset.is_borrowed_by_user(asset, user)
  end

  def can_borrow(asset) do
    Asset.is_not_borrowed(asset)
  end
end
