defmodule TakeMeThere.Places do
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Repo

  def get_places(session_id) do
    %{location_id: location_id, activities: activities_list} =
      Repo.get!(SearchSession, session_id)

    %{name: location_name, country: country} = Repo.get!(Location, location_id)
    activities = activities_list |> String.split(",")

    places_to_return = 10
    places_per_category = ceil(places_to_return / Enum.count(activities))

    activities
    |> Task.async_stream(fn activity -> get_places_by_category(activity, location_name, country) end)
    |> Enum.map(fn {:ok, places} -> places |> Enum.take(places_per_category) end)
    |> Enum.flat_map(fn place -> place end)
    |> Enum.sort_by(fn %{"rating" => rating} -> rating end, :desc)
  end

  defp get_places_by_category(category, location_name, country) do
    query = build_place_search_query(category, location_name, country)
    params = api_config().params ++ [query: query]

    %{body: body} = HTTPoison.get!("#{api_config().url}/textsearch/json", [], params: params)

    %{"results" => results} = Jason.decode!(body)

    results
    |> Stream.filter(fn place -> Map.has_key?(place, "photos") end)
    |> Enum.map(fn %{
                     "formatted_address" => address,
                     "geometry" => %{"location" => location},
                     "name" => name,
                     "photos" => [%{"photo_reference" => photo_reference} | _],
                     "rating" => rating,
                     "types" => types
                   } ->
      %{
        "name" => name,
        "address" => address,
        "location" => location,
        "photo_reference" => photo_reference,
        "rating" => rating,
        "tags" => types
      }
    end)
    |> Enum.take(5)
    |> Task.async_stream(fn place -> place |> Map.put_new("image_url", get_photo(place["photo_reference"])) end)
    |> Enum.map(fn {:ok, place} -> place |> Map.delete("photo_reference") end)
  end

  defp get_photo(photo_reference) do
    params = api_config().params ++ [
      photo_reference: photo_reference,
      maxwidth: 700
    ]

    %{body: body} = HTTPoison.get!("#{api_config().url}/photo", [], params: params)
    image_url_pattern = ~r/HREF=\"(.+)\"/
    [_, url] = Regex.run(image_url_pattern, body)
    url
  end

  defp build_place_search_query(activity, location, country),
    do: "#{activity} in #{location},#{country}"

  defp api_config() do
    %{
      url: "https://maps.googleapis.com/maps/api/place",
      params: [
        key: Application.get_env(:takemethere, :google_maps_key)
      ]
    }
  end
end
