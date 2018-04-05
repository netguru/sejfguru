defmodule Sejfguru.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :department_name, :string
      add :description, :string
      add :freshservice_id, :integer
      add :location_name, :string
      add :name, :string
      add :product_name, :string
      add :state_name, :string
      add :tag, :string
      add :type_name, :string
      add :used_by, :string
      add :values, :map
      add :vendor_name, :string

      timestamps()
    end

    create index(:assets, :freshservice_id, unique: true)
  end
end
