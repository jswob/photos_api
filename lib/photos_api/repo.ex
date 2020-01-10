defmodule PhotosApi.Repo do
  use Ecto.Repo,
    otp_app: :photos_api,
    adapter: Ecto.Adapters.Postgres
end
