defmodule PhotosApiWeb.UserController do
  use PhotosApiWeb, :controller

  def index(_conn, _params) do
    # Here api will return all users
  end

  def show(_conn, %{"id" => _id}) do
    # Here api will return selected user
  end

  def create(_conn, _params) do
    # Here api will create user
  end

  def update(_conn, %{"id" => _id}) do
    # Here api will update selected user
  end

  def delete(_conn, %{"id" => _id}) do
    # Here api will delete selected user
  end
end
