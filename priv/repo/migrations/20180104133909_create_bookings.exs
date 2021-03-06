defmodule Sejfguru.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :fs_device_id, :string
      add :user_id, references(:users)
      add :returned_at, :utc_datetime

      timestamps()
    end
  end
end
