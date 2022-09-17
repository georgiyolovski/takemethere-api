defmodule TakeMeThereWeb.FlightsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Flights

  def get_prices(conn, %{"search_session" => session_id}) do
    resp = Flights.get_flights(session_id)

    conn
    |> json(resp)
  end

  def get_booking_url(conn, params) do
    resp = Flights.get_booking_url(params)

    conn
    |> json(resp)
  end
end
