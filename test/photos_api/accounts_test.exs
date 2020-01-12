defmodule PhotosApi.AccountsTest do
  use PhotosApi.DataCase, async: true

  alias PhotosApi.Accounts
  alias PhotosApi.Accounts.User

  @good_user %{
    name: "some name"
  }

  test "with correct data insert user" do
    {:ok, %User{id: id} = user} = Accounts.create_user(@good_user)
    assert user.name === "some name"
    assert [%User{id: ^id}] = Accounts.list_users()
  end

  test "with incorrect data don't insert user" do
    {:error, changeset} = Accounts.create_user(%{name: ""})
    errors = errors_on(changeset)
    assert errors.name === ["can't be blank"]
    assert !Enum.find(Accounts.list_users(), fn user -> user.id === changeset.data.id end)
  end

  test "update_user/2 correctly updates user" do
    {:ok, %User{id: id} = user} = Accounts.create_user(@good_user)
    assert user.name === "some name"
    {:ok, %User{name: new_name} = updated_user} = Accounts.update_user(user, %{name: "new name"})
    assert new_name === "new name"
    assert [%User{id: ^id, name: ^new_name}] = Accounts.list_users()
  end

  test "delete_user/1 correctly deletes user" do
    {:ok, %User{id: id} = user} = Accounts.create_user(@good_user)
    {:ok, %User{id: deleted_id}} = Accounts.delete_user(user)
    assert id === deleted_id
    assert !Enum.find(Accounts.list_users(), fn user -> user.id === id end)
  end
end
