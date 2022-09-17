defmodule TakeMeThere.Repo.Migrations.CreateSearchSessions do
  use Ecto.Migration

  def change do
    create table("search_sessions") do
      add :location_id, :integer
      add :user_id, :integer
      add :start_date, :date
      add :end_date, :date
      add :adults, :integer
      add :children, :integer
      add :activities, :string

      timestamps()
    end

    create index("search_sessions", [:location_id])
  end
end
