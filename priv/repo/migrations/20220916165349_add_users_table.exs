defmodule TakeMeThere.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :avatar_url, :string
      add :password_hash, :string
      timestamps()
    end
  end
end
