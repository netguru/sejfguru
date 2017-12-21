defmodule Sejfguru.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :image, :string
      add :google_uid, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:google_uid])
  end
end
