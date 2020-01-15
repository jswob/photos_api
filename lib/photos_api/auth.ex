defmodule PhotosApi.Auth do
  import Ecto.Query

  alias PhotosApi.Repo
  alias PhotosApi.Accounts.User

  def authenticate_user(name, password) do
    query = from(u in User, where: u.name == ^name)

    query
    |> Repo.one()
    |> verify_password(password)
  end

  defp verify_password(nil, _) do
    Bcrypt.no_user_verify()
    {:error, "Wrong name or password"}
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Wrong name or password"}
    end
  end
end
