defmodule PhotosApiWeb.Router do
  use PhotosApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhotosApiWeb do
    pipe_through :api
  end
end
