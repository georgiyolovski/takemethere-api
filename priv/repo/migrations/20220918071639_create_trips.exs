defmodule TakeMeThere.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table("trips") do
      add :user_id, :integer
      add :location_id, :integer
      add :start_date, :date
      add :end_date, :date
      add :adults, :integer
      add :children, :integer
      add :activities, :string
      add :cover_url, :string
      add :tickets, :map
      add :hotels, :map
      add :places, :map

      timestamps()
    end

    create index("trips", [:user_id])
    create index("trips", [:location_id])
  end
end
