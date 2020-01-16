defmodule PhotosApi.Multimedia.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :description, :string
    field :name, :string
    field :url, :string
    belongs_to :user, PhotosApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:url, :description, :name])
    |> validate_required([:url, :description, :name])
  end
end
