defmodule TakeMeThere.Repo.Migrations.AddLocations do
  use Ecto.Migration

  def change do
    create table("airports") do
      add :name, :string
      add :location_name, :string
      add :latitude_deg, :float
      add :longitude_deg, :float
      add :continent, :string
      add :country, :string
      add :region, :string
      add :iata_code, :string
      timestamps()
    end

    create table("countries") do
      add :name, :string
      add :short_code, :string
      add :long_code, :string
      add :phone_code, :string
      add :region, :string
      add :sub_region, :string
      add :intermediate_region, :string
      timestamps()
    end
  end
end
