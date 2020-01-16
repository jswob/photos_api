defmodule PhotosApiWeb.UserControllerTest do
  use PhotosApiWeb.ConnCase

  alias PhotosApi.Accounts.User

  @create_attrs %{
    name: "some name",
    password: "some password"
  }
  @update_attrs %{
    name: "some updated name",
    password: "some updated password"
  }
  @invalid_attrs %{name: nil, password: nil}
  @current_user_attrs %{
    name: "current user name",
    password: "current user password"
  }

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn, @current_user_attrs)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "index" do
    test "lists all users", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => current_user.id,
                 "name" => current_user.name
               }
             ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "sign_in user" do
    test "renders user when user credentials are good", %{conn: conn, current_user: current_user} do
      conn =
        post(
          conn,
          Routes.user_path(conn, :sign_in, %{
            name: current_user.name,
            password: @current_user_attrs.password
          })
        )

      assert json_response(conn, 200)["data"] == %{
               "user" => %{
                 "id" => current_user.id,
                 "name" => current_user.name
               }
             }
    end

    test "renders errors when user credentials are bad", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.user_path(conn, :sign_in, %{
            name: "non-existet name",
            password: "non-existed password"
          })
        )

      assert json_response(conn, 401)["errors"] == %{"detail" => "Wrong name or password"}
    end
  end

  defp create_user(_) do
    user = user_fixture(@create_attrs)
    {:ok, user: user}
  end
end
