defmodule TakeMeThere.Hotels do
  import Ecto.Query
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Locations.Airport
  alias TakeMeThere.Repo

  def get_list_of_hotels(session_id) do
    %{location_id: location_id, start_date: checkin_date, end_date: checkout_date, adults: adults} =
      Repo.get!(SearchSession, session_id)

    %{name: city} = Repo.get!(Location, location_id)

    airport_coords =
      from(a in Airport)
      |> where([a], a.location_name == ^city)
      |> select([a], %{"latitude" => a.latitude_deg, "longitude" => a.longitude_deg})
      |> Repo.all()
      |> List.first()

    %{"searchResults" => %{"results" => results}} =
      build_hotels_search_request(airport_coords, checkout_date, checkin_date, adults)

    total_pattern = ~r/\$([0-9,]+)\s/

    results
    |> Enum.map(fn %{
                     "id" => id,
                     "name" => name,
                     "address" => address,
                     "ratePlan" => %{
                       "price" => %{"fullyBundledPricePerStay" => full_price}
                     },
                     "guestReviews" => %{
                       "rating" => rating
                     }
                   } ->
      %{
        "id" => id,
        "name" => name,
        "full_price" =>
          Regex.run(total_pattern, full_price)
          |> List.last()
          |> String.replace(",", "")
          |> Float.parse()
          |> elem(0),
        "rating" => rating |> Float.parse() |> elem(0),
        "address" => get_address(address)
      }
    end)
    |> Enum.take(5)
    |> Task.async_stream(
      fn hotel -> hotel |> Map.put_new("picture_url", get_photo(hotel["id"])) end,
      max_concurrency: 2
    )
    |> Enum.map(fn {:ok, data} -> data end)
    |> Enum.sort_by(fn %{"rating" => rating} -> rating end, :desc)
  end

  def get_booking_url(%{"name" => name, "start_date" => start_date, "end_date" => end_date, "adults" => adults}) do
    base_url = "https://www.hotels.com/Hotel-Search?"
    params = %{
      "d1" => start_date,
      "d2" => start_date,
      "startDate" => start_date,
      "endDate" => end_date,
      "destination" => name,
      "hotels-destination" => name,
      "directFlights" => "false",
      "partialStay" => "false",
      "sort" => "RECOMMENDED",
      "adults" => adults
    }
    %{
      "url" => "#{base_url}?#{URI.encode_query(params)}"
    }
  end

  defp get_address(%{"fullAddress" => address}), do: address

  defp get_address(%{"countryName" => country, "locality" => locality, "streetAddress" => address}),
       do: "#{address}, #{locality}, #{country}"

  defp get_address(%{"streetAddress" => address}), do: address

  defp get_address(_), do: ""

  defp get_photo(hotel_id) do
    params = [
      hotel_id: hotel_id
    ]

    %{body: body} =
      HTTPoison.get!("#{api_config().url}/v1/hotels/photos", api_config().headers, params: params)

    [%{"mainUrl" => picture} | _] = Jason.decode!(body)
    picture
  end

  defp build_hotels_search_request(
         %{"latitude" => latitude, "longitude" => longitude},
         checkout_date,
         checkin_date,
         adults
       ) do
    params = [
      latitude: latitude,
      currency: "USD",
      longitude: longitude,
      checkout_date: checkout_date,
      sort_order: "STAR_RATING_HIGHEST_FIRST",
      checkin_date: checkin_date,
      adults_number: adults,
      locale: "en_US"
    ]

    %{body: body} =
      HTTPoison.get!("#{api_config().url}/v1/hotels/nearby", api_config().headers, params: params)

    body
    |> Jason.decode!()
  end

  defp api_config() do
    %{
      url: "https://hotels-com-provider.p.rapidapi.com",
      headers: [
        "X-RapidAPI-Key": Application.get_env(:takemethere, :rapidapi_key)
      ]
    }
  end
end
