defmodule PhotosApi.MultimediaTest do
  use PhotosApi.DataCase

  alias PhotosApi.Multimedia

  describe "photos" do
    alias PhotosApi.Multimedia.Photo

    @valid_attrs %{description: "some description", name: "some name", url: "some url"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      url: "some updated url"
    }
    @invalid_attrs %{description: nil, name: nil, url: nil}

    test "list_photos/0 returns all photos" do
      user = user_fixture()
      %Photo{id: id} = photo_fixture(user)
      assert [%Photo{id: ^id}] = Multimedia.list_photos()
    end

    test "get_photo!/1 returns the photo with given id" do
      user = user_fixture()
      %Photo{id: id} = photo_fixture(user)
      assert %Photo{id: ^id} = Multimedia.get_photo!(id)
    end

    test "create_photo/1 with valid data creates a photo" do
      user = user_fixture()
      assert {:ok, %Photo{} = photo} = Multimedia.create_photo(user, @valid_attrs)
      assert photo.description == "some description"
      assert photo.name == "some name"
      assert photo.url == "some url"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_photo(user, @invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      user = user_fixture()
      photo = photo_fixture(user)
      assert {:ok, %Photo{} = photo} = Multimedia.update_photo(photo, @update_attrs)
      assert photo.description == "some updated description"
      assert photo.name == "some updated name"
      assert photo.url == "some updated url"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      user = user_fixture()
      photo = photo_fixture(user)
      id = photo.id
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_photo(photo, @invalid_attrs)
      assert %Photo{id: ^id} = Multimedia.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      user = user_fixture()
      photo = photo_fixture(user)
      assert {:ok, %Photo{}} = Multimedia.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      user = user_fixture()
      photo = photo_fixture(user)
      assert %Ecto.Changeset{} = Multimedia.change_photo(photo)
    end
  end
end
