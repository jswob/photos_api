defmodule PhotosApiWeb.Router do
  use PhotosApiWeb, :router

  alias PhotosApi.Accounts

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PhotosApi.Auth
  end

  pipeline :api_auth do
    plug PhotosApi.Auth, :ensure_authenticated
  end

  scope "/api", PhotosApiWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", PhotosApiWeb do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, except: [:new, :edit]
    resources "/photos", PhotoController, exept: [:new, :edit]
  end
end
