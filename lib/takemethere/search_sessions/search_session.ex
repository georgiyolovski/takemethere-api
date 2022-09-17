defmodule TakeMeThere.SearchSessions.SearchSession do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:location_id, :start_date, :end_date, :adults, :children, :activities, :user_id]

  schema "search_sessions" do
    field :activities, :string
    field :adults, :integer
    field :children, :integer
    field :end_date, :date
    field :location_id, :integer
    field :user_id, :integer
    field :start_date, :date

    timestamps()
  end

  @doc false
  def changeset(search_session, attrs) do
    search_session
    |> cast(attrs, @fields)
  end
end
