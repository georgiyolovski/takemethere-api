defmodule TakeMeThere.User do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:email, :first_name, :last_name, :avatar_url, :password_hash]

  @type t() :: %__MODULE__{}

  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:avatar_url, :string)
    field(:password_hash, :string)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
  end
end
