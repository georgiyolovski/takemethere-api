defmodule TakeMeThere.Repo.Migrations.AddLocationsTable do
  use Ecto.Migration

  def change do
    create table("locations") do
      add :name, :string
      add :country, :string
      add :continent, :string
      timestamps()
    end
  end
end
