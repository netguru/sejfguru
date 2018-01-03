defmodule SejfguruWeb.PageControllerTest do
  use SejfguruWeb.ConnCase

  alias Sejfguru.Accounts
  alias SejfguruWeb.Guardian

  describe "GET /protected" do
    test "renders user name", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{
        first_name: "John",
        last_name: "Doe",
        email: "test@example.com",
        image: "http://example.com/image.jpg",
        google_uid: "123456",
      })
      conn =
        conn
        |> Guardian.Plug.sign_in(user)
        |> get(page_path(conn, :protected))

      assert html_response(conn, 200) =~ "Hello John"
    end

    test "requires user to be sign in", %{conn: conn} do
      conn = get(conn, page_path(conn, :protected))

      assert redirected_to(conn) === page_path(conn, :index)
      assert get_flash(conn, :error) === "unauthenticated"
    end
  end
end
