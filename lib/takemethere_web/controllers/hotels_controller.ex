defmodule TakeMeThereWeb.HotelsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Hotels

  def get_hotels(conn, %{"search_session" => session_id}) do
    resp = Hotels.get_list_of_hotels(session_id)

    conn
    |> json(resp)
  end

  def get_booking_url(conn, params) do
    resp = Hotels.get_booking_url(params)

    conn
    |> json(resp)
  end
end
