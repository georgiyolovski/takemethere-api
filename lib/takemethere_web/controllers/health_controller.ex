defmodule TakeMeThereWeb.HealthController do
  use TakeMeThereWeb, :controller

  def status(conn, _) do
    conn
    |> json(%{
      "status" => "UP"
    })
  end
end
