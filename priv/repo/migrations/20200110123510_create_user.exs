defmodule PhotosApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
    end

    create unique_index(:users, [:name])
  end
end
