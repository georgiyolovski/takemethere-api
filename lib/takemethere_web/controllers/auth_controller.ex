defmodule TakeMeThereWeb.AuthController do
  use TakeMeThereWeb, :controller

  alias TakeMeThere.Auth.Token
  alias TakeMeThere.Users

  @spec register(any, map) :: nil
  def register(conn, user) do
    created =
      user
      |> Users.register()

    conn
    |> json(user_token_response(created))
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = Users.login(email, password)

    conn
    |> json(user_token_response(user))
  end

  def google_register(conn, %{"token" => token}) do
    user = Users.google_register(token)

    conn
    |> json(user_token_response(user))
  end

  def google_login(conn, %{"token" => token}) do
    user = Users.google_login(token)

    conn
    |> json(user_token_response(user))
  end

  defp user_token_response(user) do
    {:ok, token, _} =
      user
      |> Token.generate_and_sign()

    %{token: token}
  end
end
