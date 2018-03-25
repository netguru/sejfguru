defmodule Sejfguru.Repo.Migrations.AlterFsDeviceIdInBookings do
  use Ecto.Migration

  def up do
    alter table(:bookings) do
      remove :fs_device_id
      add :fs_device_id, :integer, null: false
    end

    create index(:bookings, [:fs_device_id])
  end

  def down do
    raise Ecto.MigrationError, message: "fs_device_id is always passed as id!"
  end
end
