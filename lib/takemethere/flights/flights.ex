defmodule TakeMeThere.Flights do
  import Ecto.Query
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Locations.Airport
  alias TakeMeThere.Repo

  def get_flights(session_id) do
    %{start_date: start_date, end_date: end_date, location_id: location_id, adults: adults} =
      Repo.get!(SearchSession, session_id)

    location = Repo.get!(Location, location_id)

    airport =
      from(a in Airport)
      |> where([a], a.location_name == ^location.name)
      |> Repo.all()
      |> List.first()

    price_tasks = [
      Task.async(fn -> get_tickets("SOF", airport.iata_code, start_date, adults) end),
      Task.async(fn -> get_tickets(airport.iata_code, "SOF", end_date, adults) end)
    ]

    [outgoing, return] = Task.await_many(price_tasks, 120_000)

    %{
      "outgoing" => outgoing |> Enum.take(3),
      "return" => return |> Enum.take(3)
    }
  end

  def get_booking_url(%{
        "search_hash" => search_hash,
        "destination" => destination,
        "id" => id,
        "origin" => origin,
        "search_id" => search_id,
        "impression_id" => impression_id
      }) do
    params = [
      searchHash: search_hash,
      Dest: destination,
      id: id,
      Orig: origin,
      searchId: search_id,
      imppressionId: impression_id
    ]

    %{body: body} =
      HTTPoison.get!("#{api_config().url}/get-booking-url", api_config().headers, params: params)

    %{"partner_url" => url} = Jason.decode!(body)

    %{
      "booking_url" => url
    }
  end

  defp get_tickets(origin, destination, date, adults) do
    %{body: body} = build_flights_search_request(origin, destination, date, adults)
    session = Jason.decode!(body)

    %{"search_params" => %{"sid" => sid}, "summary" => %{"c" => complete}} = session

    poll_session(sid, session, complete)
    |> map_search_result()
  end

  defp build_flights_search_request(origin, destination, date, adults) do
    params = [
      o1: origin,
      d1: destination,
      dd1: date,
      currency: "BGN",
      ta: adults
    ]

    HTTPoison.get!("#{api_config().url}/create-session", api_config().headers, params: params)
  end

  defp poll_session(sid, _previous_result, false) do
    IO.inspect("Polling #{sid} for results")
    :timer.sleep(1000)

    params = [
      sid: sid,
      so: "ML_BEST_VALUE"
    ]

    %{body: body} =
      HTTPoison.get!("#{api_config().url}/poll", api_config().headers, params: params)

    parsed = Jason.decode!(body)
    %{"summary" => %{"c" => complete}} = parsed

    poll_session(sid, parsed, complete)
  end

  defp poll_session(_sid, previous_result, true), do: previous_result

  defp map_search_result(%{
    "carriers" => carriers,
    "itineraries" => itineraries,
    "summary" => %{"sh" => hash},
    "search_params" => %{"sid" => sid}
  }) do
    carrier_map =
      carriers
      |> Map.new(fn %{"c" => key} = carrier -> {key, carrier} end)

    itineraries
    |> Enum.map(fn %{
                     "f" => [%{"l" => legs, "lo" => notes} | _],
                     "l" => [%{"pr" => price} = fare | _]
                   } ->
      %{
        "legs" =>
          legs
          |> Enum.map(fn %{
                           "ad" => arrival_time,
                           "aa" => arrival_destination,
                           "da" => departure,
                           "dd" => departure_time,
                           "m" => carrier
                         } ->
            %{
              "destination" => arrival_destination,
              "arrival_time" => arrival_time,
              "departure" => departure,
              "departure_time" => departure_time,
              "carrier" => %{
                "name" => carrier_map[carrier]["n"],
                "logo" => carrier_map[carrier]["l"]
              }
            }
          end),
        "notes" => notes |> Enum.map(fn %{"t" => note} -> note end),
        "price" => %{
          "id" => fare["id"],
          "impressionId" => fare["impressionId"],
          "amount" => price["p"] + price["f"]
        },
        "search_hash" => hash,
        "search_id" => sid
      }
    end)
  end

  defp map_search_result(_), do: []

  defp api_config() do
    %{
      url: "https://travel-advisor.p.rapidapi.com/flights",
      headers: [
        "X-RapidAPI-Key": Application.get_env(:takemethere, :rapidapi_key)
      ]
    }
  end
end
