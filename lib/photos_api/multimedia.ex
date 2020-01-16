defmodule PhotosApi.Multimedia do
  import Ecto.Query, warn: false
  alias PhotosApi.Repo

  alias PhotosApi.Multimedia.Photo
  alias PhotosApi.Accounts.User

  def list_photos do
    Repo.all(Photo)
  end

  def list_user_photos(%User{} = user) do
    Photo
    |> user_photos_query(user)
    |> Repo.all()
  end

  def get_photo!(id), do: Repo.get!(Photo, id)

  @spec get_user_photo!(PhotosApi.Accounts.User.t(), any) :: any
  def get_user_photo!(%User{} = user, id) do
    Photo
    |> user_photos_query(user)
    |> Repo.get!(id)
  end

  def create_photo(%User{} = user, attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end

  defp user_photos_query(query, %User{id: user_id}) do
    from(p in query, where: p.user_id == ^user_id)
  end
end
