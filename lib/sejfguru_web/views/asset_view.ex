defmodule SejfguruWeb.AssetView do
  use SejfguruWeb, :view

  def last_user(asset) do
    booking = List.last(asset.bookings)
    if booking do
      "#{booking.user.first_name} #{booking.user.last_name}"
    else
      "N/A"
    end
  end

  def last_borrowed_at(asset) do
    booking = List.last(asset.bookings)
    if booking do
      datetime = booking.inserted_at
      "#{datetime.day}/#{datetime.month}/#{datetime.year} #{datetime.hour}:#{datetime.minute}"
    else
      "N/A"
    end
  end
end
