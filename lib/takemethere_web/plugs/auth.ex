defmodule TakeMeThereWeb.Plugs.Auth do
  import Plug.Conn
  alias TakeMeThere.Auth.Token

  def init(opts), do: opts

  def call(%{req_headers: headers} = conn, _opts) do
    auth_header =
      headers
      |> Enum.find(fn {name, _} -> name == "authorization" end)

    with {_, token} <- auth_header,
      {:ok, user} <- Token.verify_and_validate(token) do
        conn
        |> assign(:user, user)

      else
        _ ->
          send_error(conn)
    end
  end

  defp send_error(conn) do
    send_resp(conn, 401, Jason.encode!(%{error: "unauthorized"}))
    |> halt()
  end
end
