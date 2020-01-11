ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PhotosApi.Repo, :manual)

defmodule PhotosApi.TestHelpers do
  alias PhotosApi.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{name: "some name"})
      |> Accounts.create_user()

    user
  end
end
