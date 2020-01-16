defmodule PhotosApiWeb.PhotoController do
  use PhotosApiWeb, :controller

  alias PhotosApi.Multimedia
  alias PhotosApi.Multimedia.Photo

  action_fallback PhotosApiWeb.FallbackController

  def action(conn, _params) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    photos = Multimedia.list_user_photos(current_user)
    render(conn, "index.json", photos: photos)
  end

  def create(conn, %{"photo" => photo_params}, current_user) do
    with {:ok, %Photo{} = photo} <- Multimedia.create_photo(current_user, photo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.photo_path(conn, :show, photo))
      |> render("show.json", photo: photo)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    photo = Multimedia.get_user_photo!(current_user, id)
    render(conn, "show.json", photo: photo)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}, current_user) do
    photo = Multimedia.get_user_photo!(current_user, id)

    with {:ok, %Photo{} = photo} <- Multimedia.update_photo(photo, photo_params) do
      render(conn, "show.json", photo: photo)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    photo = Multimedia.get_user_photo!(current_user, id)

    with {:ok, %Photo{}} <- Multimedia.delete_photo(photo) do
      send_resp(conn, :no_content, "")
    end
  end
end
