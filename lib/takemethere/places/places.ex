defmodule TakeMeThere.Places do
  import Ecto.Query
  alias TakeMeThere.SearchSessions.SearchSession
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Locations.Airport
  alias TakeMeThere.Repo

  def get_places(session_id) do
    %{location_id: location_id, activities: activities_list} =
      Repo.get!(SearchSession, session_id)

    %{name: location_name, country: country} = Repo.get!(Location, location_id)
    activities = activities_list |> String.split(",")
    get_places_by_category(List.first(activities), location_name, country)
  end

  defp get_places_by_category(category, location_name, country) do
    query = build_place_search_query(category, location_name, country)
    params = api_config().params ++ [query: query]

    %{body: body} = HTTPoison.get!("#{api_config().url}/textsearch/json", [], params: params)

    %{"results" => results} = Jason.decode!(body)

    results
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

  defp build_place_search_query("beach", location, country),
    do: "beaches in #{location},#{country}"

  defp api_config() do
    %{
      url: "https://maps.googleapis.com/maps/api/place",
      params: [
        key: Application.get_env(:takemethere, :google_maps_key)
      ]
    }
  end
end
