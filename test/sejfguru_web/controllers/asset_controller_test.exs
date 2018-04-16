defmodule SejfguruWeb.AssetControllerTest do
  use SejfguruWeb.ConnCase

  alias Sejfguru.Accounts
  alias SejfguruWeb.Guardian

  describe "GET /assets" do
    test "renders page with devices", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{
        first_name: "John",
        last_name: "Doe",
        email: "test@example.com",
        image: "http://example.com/image.jpg",
        google_uid: "123456",
      })

      Sejfguru.Assets.create_asset(%{freshservice_id: 523, type_name: "Mobile", name: "Test device"})

      conn =
        conn
        |> Guardian.Plug.sign_in(user)
        |> get(asset_path(conn, :index))

      assert html_response(conn, 200) =~ "Hello, John"
      assert html_response(conn, 200) =~ "Test device"
      assert html_response(conn, 200) =~ "523"
    end

    test "requires user to be sign in", %{conn: conn} do
      conn = get(conn, asset_path(conn, :index))

      assert redirected_to(conn) === page_path(conn, :login)
      assert get_flash(conn, :error) === "unauthenticated"
    end
  end
end
