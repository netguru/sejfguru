defmodule SejfguruWeb.PageControllerTest do
  use SejfguruWeb.ConnCase

  alias Sejfguru.Accounts
  alias SejfguruWeb.Guardian

  describe "GET /login" do
    test "redirects logged in user", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          first_name: "John",
          last_name: "Doe",
          email: "test@example.com",
          image: "http://example.com/image.jpg",
          google_uid: "123456"
        })

      conn =
        conn
        |> Guardian.Plug.sign_in(user)
        |> get(page_path(conn, :login))

      assert html_response(conn, 200) =~ "Login with Google"
    end

    test "does not require user to be sign in", %{conn: conn} do
      conn = get(conn, page_path(conn, :login))

      assert html_response(conn, 200)
      refute get_flash(conn, :error) === "unauthenticated"
    end
  end
end
