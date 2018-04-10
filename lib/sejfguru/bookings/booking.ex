defmodule Sejfguru.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Bookings.Booking


  schema "bookings" do
    field :returned_at, :utc_datetime
    belongs_to :user, Sejfguru.Accounts.User
    belongs_to :asset, Sejfguru.Assets.Asset

    timestamps()
  end

  @doc false
  def changeset(%Booking{} = booking, attrs) do
    booking
    |> cast(attrs, [:asset_id, :user_id])
    |> validate_required([:asset_id, :user_id])
  end
end
