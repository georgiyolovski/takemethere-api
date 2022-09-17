defmodule TakeMeThere.Locations.Airport do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :location, :latitude_deg, :longitude_deg, :continent, :country, :region, :iata_code]

  @type t() :: %__MODULE__{}

  schema "airports" do
    field(:name, :string)
    field(:location_name, :string)
    field(:latitude_deg, :float)
    field(:longitude_deg, :float)
    field(:continent, :string)
    field(:country, :string)
    field(:region, :string)
    field(:iata_code, :string)

    timestamps()
  end

  def changeset(airport, attrs) do
    airport
    |> cast(attrs, @fields)
  end
end
