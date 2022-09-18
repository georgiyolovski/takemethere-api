defmodule TakeMeThere.Trips.Trip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trips" do
    field :activities, :string
    field :adults, :integer
    field :children, :integer
    field :end_date, :date
    field :hotels, :map
    field :location_id, :integer
    field :places, :map
    field :start_date, :date
    field :tickets, :map
    field :user_id, :integer
    field :cover_url, :string

    timestamps()
  end

  @doc false
  def changeset(trip, attrs) do
    trip
    |> cast(attrs, [
      :user_id,
      :location_id,
      :start_date,
      :end_date,
      :adults,
      :children,
      :activities,
      :tickets,
      :hotels,
      :places,
      :cover_url
    ])
  end
end
