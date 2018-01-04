defmodule Sejfguru.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Booking


  schema "bookings" do
    field :fs_device_id, :string
    field :returned_at, :utc_datetime
    belongs_to :users, Sejfguru.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Booking{} = booking, attrs) do
    booking
    |> cast(attrs, [:fs_device_id, :user_id])
    |> validate_required([:fs_device_id, :user_id])
  end
end
