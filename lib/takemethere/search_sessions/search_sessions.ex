defmodule TakeMeThere.SearchSessions do
  import Ecto.Query
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Repo

  def get(id) do
    from(s in SearchSession)
    |> where([s], s.id == ^id)
    |> join(:inner, [s], l in Location, on: s.location_id == l.id)
    |> select([s, l], %{
      "id" => s.id,
      "start_date" => s.start_date,
      "end_date" => s.end_date,
      "adults" => s.adults,
      "children" => s.children,
      "activities" => s.activities,
      "location" => %{"id" => l.id, "name" => l.name}
    })
    |> Repo.one!()
    |> map_activities()
  end

  def create(%{
        "location_id" => location_id,
        "start_date" => start_date,
        "end_date" => end_date,
        "adults" => adults,
        "children" => children,
        "activities" => activities,
        "user_id" => user_id
      }) do
    session_to_add = %{
      location_id: location_id,
      user_id: user_id,
      start_date: start_date,
      end_date: end_date,
      adults: adults,
      children: children,
      activities: if(activities != nil, do: activities |> Enum.join(","), else: nil)
    }

    %SearchSession{}
    |> SearchSession.changeset(session_to_add)
    |> Repo.insert!()
    |> schema_to_session()
  end

  defp map_activities(%{"activities" => nil} = session), do: session

  defp map_activities(%{"activities" => activities} = session) do
    session
    |> Map.put("activities", activities |> String.split(","))
  end

  defp schema_to_session(schema) do
    %{
      "id" => schema.id,
      "start_date" => schema.start_date,
      "end_date" => schema.end_date,
      "adults" => schema.adults,
      "children" => schema.children,
      "activities" => schema.activities,
      "location_id" => schema.location_id,
      "user_id" => schema.user_id
    }
    |> map_activities()
  end
end
