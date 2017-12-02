defmodule Sejfguru.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Asset


  schema "assets" do
    field :name, :string
    field :asset_type, :string
    field :brand, :string
    field :model, :string
    field :os, :string
    field :os_version, :string
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(%Asset{} = asset, attrs) do
    asset
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
