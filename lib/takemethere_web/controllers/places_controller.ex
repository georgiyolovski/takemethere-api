defmodule TakeMeThereWeb.PlacesController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Places

  def get_places(conn, %{"search_session" => session_id}) do
    resp = Places.get_places(session_id)

    conn
    |> json(resp)
  end
end
