defmodule TakeMeThere.Repo do
  use Ecto.Repo,
    otp_app: :takemethere,
    adapter: Ecto.Adapters.Postgres
end
