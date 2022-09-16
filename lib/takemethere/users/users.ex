defmodule TakeMeThere.Users do
  import Ecto.Query
  alias Comeonin.Bcrypt
  alias TakeMeThere.User
  alias TakeMeThere.Repo

  def register(%{
        "email" => email,
        "first_name" => first_name,
        "last_name" => last_name,
        "password" => password
      }) do
    %{password_hash: hash} = Bcrypt.add_hash(password)

    user_to_add =
      %{
        email: email,
        first_name: first_name,
        last_name: last_name
      }
      |> Map.put_new(:password_hash, hash)

    %User{}
    |> User.changeset(user_to_add)
    |> Repo.insert!()
    |> schema_to_user()
  end

  def login(email, password) do
    user = Repo.one(from u in User, where: u.email == ^email)

    case Bcrypt.checkpw(password, user.password_hash) do
      true ->
        user
        |> schema_to_user()

      false ->
        nil
    end
  end

  def google_register(token) do
    {:ok,
     %{
       "email" => email,
       "given_name" => first_name,
       "family_name" => last_name,
       "picture" => avatar_url
     }} = Joken.peek_claims(token)

    %{password_hash: hash} = Bcrypt.add_hash("#{first_name}#{last_name}")

    user_to_add =
      %{
        email: email,
        first_name: first_name,
        last_name: last_name,
        avatar_url: avatar_url
      }
      |> Map.put_new(:password_hash, hash)

    %User{}
    |> User.changeset(user_to_add)
    |> Repo.insert!()
    |> schema_to_user()
  end

  def google_login(token) do
    {:ok, %{"email" => email}} = Joken.peek_claims(token)
    user = Repo.one(from u in User, where: u.email == ^email)

    user
    |> schema_to_user()
  end

  defp schema_to_user(schema) do
    %{
      "id" => schema.id,
      "first_name" => schema.first_name,
      "last_name" => schema.last_name,
      "email" => schema.email,
      "avatar_url" => schema.avatar_url
    }
  end
end
