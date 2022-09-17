defmodule TakeMeThereWeb.LocationsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Locations

  def list(conn, params) do
    locations = Locations.get(params)

    conn
    |> json(locations)
  end
end
