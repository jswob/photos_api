ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PhotosApi.Repo, :manual)

defmodule PhotosApi.TestHelpers do
  alias PhotosApi.Accounts
  alias PhotosApi.Multimedia
  alias Plug.Test

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{name: "some name", password: "some new password"})
      |> Accounts.create_user()

    user
  end

  def photo_fixture(attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{description: "some description", name: "some name", url: "some url"})
      |> Multimedia.create_photo()

    photo
  end

  def setup_current_user(conn, attrs) do
    current_user = user_fixture(attrs)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user}
  end
end
