defmodule Sejfguru.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Bookings.Booking


  schema "bookings" do
    field :fs_device_id, :integer
    field :returned_at, :utc_datetime
    belongs_to :user, Sejfguru.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Booking{} = booking, attrs) do
    booking
    |> cast(attrs, [:fs_device_id, :user_id])
    |> validate_required([:fs_device_id, :user_id])
  end
end
