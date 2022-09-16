defmodule TakeMeThere.Users do
  import Ecto.Query
  alias Comeonin.Bcrypt
  alias TakeMeThere.User
  alias TakeMeThere.Repo

  def register(user) do
    user_to_add = user
    |> Map.delete(:password)
    |> Map.put_new(:password_hash, Bcrypt.hashpwsalt(user.password))

    %User{}
    |> User.changeset(user_to_add)
    |> Repo.insert!()
  end
end
