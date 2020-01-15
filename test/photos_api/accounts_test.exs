defmodule PhotosApi.AccountsTest do
  use PhotosApi.DataCase, async: true

  alias PhotosApi.Accounts
  alias PhotosApi.Accounts.User

  describe "users" do
    @valid_attrs %{
      name: "some name",
      password: "some password"
    }
    @update_attrs %{
      name: "updated name",
      password: "some updated password"
    }
    @invalid_attrs %{name: nil, password: nil}

    test "with correct data insert user" do
      {:ok, %User{id: id} = user} = Accounts.create_user(@valid_attrs)
      assert user.name === "some name"
      assert [%User{id: ^id}] = Accounts.list_users()
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "with incorrect data don't insert user" do
      {:error, changeset} = Accounts.create_user(@invalid_attrs)
      errors = errors_on(changeset)
      assert errors.name === ["can't be blank"]
      assert !Enum.find(Accounts.list_users(), fn user -> user.id === changeset.data.id end)
    end

    test "update_user/2 correctly updates user" do
      {:ok, %User{id: id} = user} = Accounts.create_user(@valid_attrs)
      assert user.name === "some name"

      {:ok, %User{name: new_name} = updated_user} = Accounts.update_user(user, @update_attrs)

      assert new_name === "updated name"
      assert [%User{id: ^id, name: ^new_name}] = Accounts.list_users()
      assert Bcrypt.verify_pass("some updated password", updated_user.password_hash)
    end

    test "delete_user/1 correctly deletes user" do
      {:ok, %User{id: id} = user} = Accounts.create_user(@valid_attrs)
      {:ok, %User{id: deleted_id}} = Accounts.delete_user(user)
      assert id === deleted_id
      assert !Enum.find(Accounts.list_users(), fn user -> user.id === id end)
    end
  end
end
