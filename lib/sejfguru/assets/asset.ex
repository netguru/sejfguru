defmodule Sejfguru.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Assets.Asset

  schema "assets" do
    field :department_name, :string
    field :description, :string
    field :freshservice_id, :integer
    field :location_name, :string
    field :name, :string
    field :product_name, :string
    field :state_name, :string
    field :tag, :string
    field :type_name, :string
    field :used_by, :string
    field :values, :map
    field :vendor_name, :string

    has_many :bookings, Sejfguru.Bookings.Booking

    timestamps()
  end

  @doc false
  def changeset(%Asset{} = asset, attrs) do
    asset
    |> cast(attrs, [:department_name, :description, :freshservice_id, :location_name,
                    :name, :product_name, :state_name, :tag, :type_name, :used_by,
                    :values, :vendor_name])
  end

  def is_borrowed(asset) do
    last_booking = asset.bookings |> Enum.sort_by(fn(x) -> x.id end) |> List.last()
    last_booking != nil && last_booking.returned_at == nil
  end

  def is_borrowed_by_user(asset, user) do
    last_booking = asset.bookings |> Enum.sort_by(fn(x) -> x.id end) |> List.last()
    last_booking != nil && last_booking.returned_at == nil && last_booking.user.id == user.id
  end

  def is_not_borrowed(asset) do
    last_booking = asset.bookings |> Enum.sort_by(fn(x) -> x.id end) |> List.last()
    last_booking == nil || (last_booking != nil && last_booking.returned_at != nil)
  end
end
