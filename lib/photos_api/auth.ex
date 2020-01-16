defmodule PhotosApi.Auth do
  import Ecto.Query
  import Plug.Conn
  import Phoenix.Controller

  alias PhotosApi.Repo
  alias PhotosApi.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = current_user_id && PhotosApi.Accounts.get_user(current_user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(name, password) do
    query = from(u in User, where: u.name == ^name)

    query
    |> Repo.one()
    |> verify_password(password)
  end

  def ensure_authenticated(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(PhotosApiWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
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
