defmodule PhotosApi.AuthTest do
  use PhotosApi.DataCase, async: true

  alias PhotosApi.Auth
  alias PhotosApi.Accounts.User

  @password "some password"

  test "authenticate_user/2 authenticates the user" do
    user = user_fixture(%{password: @password})
    assert {:error, "Wrong name or password"} = Auth.authenticate_user("wrong name", "")
    assert {:ok, authenticated_user} = Auth.authenticate_user(user.name, @password)

    assert %{
             user
             | password: nil,
               inserted_at: authenticated_user.inserted_at,
               updated_at: authenticated_user.updated_at
           } == authenticated_user
  end
end
