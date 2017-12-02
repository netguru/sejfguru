defmodule Sejfguru.Repo.Migrations.AddMoreDetailsToAssets do
  use Ecto.Migration

  def change do
    alter table(:assets) do
      add :asset_type, :string
      add :brand, :string
      add :model, :string
      add :os, :string
      add :os_version, :string
      add :notes, :text
    end
  end
end
