defmodule TakeMeThere.Trips do
  import Ecto.Query
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Trips.Trip
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Repo

  def get(user_id) do
    from(t in Trip)
    |> where([t], t.user_id == ^user_id)
    |> join(:inner, [t], l in Location, on: t.location_id == l.id)
    |> select([t, l], %{
      "location" => %{
        "name" => l.name,
        "country" => l.country
      },
      "start_date" => t.start_date,
      "end_date" => t.end_date,
      "adults" => t.adults,
      "children" => t.children,
      "activities" => t.activities,
      "tickets" => t.tickets,
      "hotels" => t.hotels,
      "places" => t.places,
      "cover_url" => t.cover_url
    })
    |> Repo.all()
    |> Enum.map(&map_activities/1)
    |> Enum.map(&add_title/1)
  end

  def create(%{
        "user_id" => user_id,
        "search_session_id" => session_id,
        "tickets" => tickets,
        "hotels" => hotels,
        "places" => places
      }) do
    %{
      location_id: location_id,
      start_date: start_date,
      end_date: end_date,
      adults: adults,
      children: children,
      activities: activities
    } = Repo.get!(SearchSession, session_id)

    [%{"image_url" => cover_url} | _] = places

    trip_to_add = %{
      "user_id" => user_id,
      "cover_url" => cover_url,
      "location_id" => location_id,
      "start_date" => start_date,
      "end_date" => end_date,
      "adults" => adults,
      "children" => children,
      "activities" => activities,
      "places" => %{"items" => places},
      "hotels" => %{"items" => hotels},
      "tickets" => %{"items" => tickets}
    }

    %Trip{}
    |> Trip.changeset(trip_to_add)
    |> Repo.insert!()
    |> schema_to_trip()
  end

  defp map_activities(%{"activities" => nil} = trip), do: trip

  defp map_activities(%{"activities" => activities} = trip) do
    trip
    |> Map.put("activities", activities |> String.split(","))
  end

  defp add_title(
         %{
           "start_date" => start_date,
           "end_date" => end_date,
           "location" => %{"name" => location, "country" => country}
         } = trip
       ) do
    days = Date.diff(end_date, start_date)
    IO.inspect({start_date, end_date})

    trip
    |> Map.put_new("title", "#{days} days in #{location}, #{country}")
  end

  def schema_to_trip(%{id: id}) do
    %{
      "id" => id
    }
  end
end
