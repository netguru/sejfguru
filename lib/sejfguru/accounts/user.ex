defmodule Sejfguru.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sejfguru.Accounts.User


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :google_uid, :string
    field :image, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :image, :google_uid])
    |> validate_required([:first_name, :last_name, :email, :image, :google_uid])
    |> unique_constraint(:email)
    |> unique_constraint(:google_uid)
  end
end
