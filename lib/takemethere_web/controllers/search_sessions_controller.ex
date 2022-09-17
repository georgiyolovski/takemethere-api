defmodule TakeMeThereWeb.SearchSessionsController do
  use TakeMeThereWeb, :controller
  alias TakeMeThere.SearchSessions

  def get(conn, %{"id" => id}) do
    session = SearchSessions.get(id)

    conn
    |> json(session)
  end

  def create(%{assigns: %{user: %{"id" => id}}} = conn, search_session) do
    created =
      search_session
      |> Map.put_new("user_id", id)
      |> SearchSessions.create()

    conn
    |> json(created)
  end
end
