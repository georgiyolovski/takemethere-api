defmodule TakeMeThere.Locations.Country do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :short_code, :long_code, :phone_code, :region, :sub_region, :intermediate_region]

  @type t() :: %__MODULE__{}

  schema "countries" do
    field(:name, :string)
    field(:short_code, :string)
    field(:long_code, :string)
    field(:phone_code, :string)
    field(:region, :string)
    field(:sub_region, :string)
    field(:intermediate_region, :string)

    timestamps()
  end

  def changeset(country, attrs) do
    country
    |> cast(attrs, @fields)
  end
end
