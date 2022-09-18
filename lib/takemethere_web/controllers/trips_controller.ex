defmodule TakeMeThereWeb.TripsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Trips

  def get(%{assigns: %{user: %{"id" => id}}} = conn, _params) do
    trips = Trips.get(id)

    conn
    |> json(trips)
  end

  def create(%{assigns: %{user: %{"id" => id}}} = conn, params) do
    created =
      params
      |> Map.put_new("user_id", id)
      |> Trips.create()

    conn
    |> json(created)
  end
end
