defmodule Sejfguru.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Asset


  schema "assets" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Asset{} = asset, attrs) do
    asset
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
