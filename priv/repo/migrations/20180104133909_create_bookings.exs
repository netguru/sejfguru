defmodule Sejfguru.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    drop table(:assets)

    create table(:bookings) do
      add :fs_device_id, :string
      add :user_id, references(:users)
      add :returned_at, :datetime

      timestamps()
    end
  end
end
