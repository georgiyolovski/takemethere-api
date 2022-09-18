defmodule TakeMeThereWeb.HotelsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.Hotels

  # def get_hotels(conn, %{"city_code" => city_code}) do
  #   resp = Hotels.get_list_of_hotels(city_code)

  #   conn
  #   |> json(resp)
  # end

  def get_hotels(conn, %{"search_session" => session_id}) do
    resp = Hotels.get_list_of_hotels(session_id)

    conn
    |> json(resp)
  end
end
