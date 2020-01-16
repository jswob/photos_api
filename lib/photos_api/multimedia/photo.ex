defmodule PhotosApi.Multimedia.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :description, :string
    field :name, :string
    field :url, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:url, :description, :name])
    |> validate_required([:url, :description, :name])
  end
end
