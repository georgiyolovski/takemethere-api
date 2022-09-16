defmodule TakeMeThereWeb.AuthController do
  use TakeMeThereWeb, :controller

  alias TakeMeThere.Users

  @spec register(any, map) :: nil
  def register(conn, %{
        "email" => email,
        "first_name" => first_name,
        "last_name" => last_name,
        "password" => password
      }) do

    %{id: id, email: email} = %{
      email: email,
      first_name: first_name,
      last_name: last_name,
      password: password
    }
    |> Users.register()
    |> Map.delete(:password_hash)

    conn
    |> json(%{id: id, email: email})
  end
end
