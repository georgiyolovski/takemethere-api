defmodule TakeMeThere.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :country, :continent]

  @type t() :: %__MODULE__{}

  schema "locations" do
    field(:name, :string)
    field(:country, :string)
    field(:continent, :string)

    timestamps()
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @fields)
  end
end
