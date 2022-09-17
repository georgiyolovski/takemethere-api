defmodule TakeMeThere.Locations do
  import Ecto.Query
  alias TakeMeThere.Locations.Location
  alias TakeMeThere.Repo

  def get(params) do
    (from l in Location)
    |> maybe_filter(:name, params)
    |> order_by(desc: fragment("continent = 'EU'"))
    |> limit(5)
    |> select([l], %{"id" => l.id, "name" => l.name, "country" => l.country})
    |> Repo.all()
  end

  defp maybe_filter(query, :name, %{"name" => name}) do
    search_string = "%#{name}%"
    query
    |> where([l], ilike(l.name, ^search_string))
  end

  defp maybe_filter(query, _, _), do: query
end
