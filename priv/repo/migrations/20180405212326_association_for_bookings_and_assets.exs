defmodule Sejfguru.Repo.Migrations.AssociationForBookingsAndAssets do
  use Ecto.Migration

  def change do
    alter table("bookings") do
      remove :fs_device_id
      add :asset_id, references("assets")
    end
  end
end
