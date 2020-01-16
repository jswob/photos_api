defmodule PhotosApiWeb.PhotoView do
  use PhotosApiWeb, :view
  alias PhotosApiWeb.PhotoView

  def render("index.json", %{photos: photos}) do
    %{data: render_many(photos, PhotoView, "photo.json")}
  end

  def render("show.json", %{photo: photo}) do
    %{data: render_one(photo, PhotoView, "photo.json")}
  end

  def render("photo.json", %{photo: photo}) do
    %{id: photo.id,
      url: photo.url,
      description: photo.description,
      name: photo.name}
  end
end
