defmodule SejfguruWeb.AuthControllerTest do
  use SejfguruWeb.ConnCase

  describe "GET /auth" do
    test "redirects to google signin page", %{conn: conn} do
      conn = get(conn, auth_path(conn, :request))

      assert redirected_to(conn) ===
               "https://accounts.google.com/o/oauth2/v2/auth?client_id=test_client_id&hd=example.com&redirect_uri=http%3A%2F%2Fwww.example.com%2Fauth-callback&response_type=code&scope=email"
    end

    test "passes client_id, hd and scope params", %{conn: conn} do
      redirect_url =
        conn
        |> get(auth_path(conn, :request))
        |> redirected_to

      assert redirect_url =~ "client_id=test_client_id"
      assert redirect_url =~ "hd=example.com"
      assert redirect_url =~ "scope=email"
    end
  end

  describe "GET /auth-callback" do
    test "successful auth signs user in", %{conn: conn} do
      user_data = %{
        first_name: "John",
        last_name: "Doe",
        email: "test@example.com",
        image: "http://example.com/image.jpg"
      }

      extra_data = %{raw_info: %{user: %{"hd" => "example.com"}}}

      conn =
        conn
        |> assign(:ueberauth_auth, %{
          provider: :google,
          info: user_data,
          uid: "123456",
          extra: extra_data
        })
        |> get("/auth-callback")

      assert get_flash(conn, :info) === "Successfully authenticated John"
      assert redirected_to(conn) === root_path(conn, :index)
      assert Guardian.Plug.current_resource(conn).google_uid === "123456"
    end

    test "spoofed domain causes auth failure", %{conn: conn} do
      extra_data = %{raw_info: %{user: %{"hd" => "spoofed.com"}}}

      conn =
        conn
        |> assign(:ueberauth_auth, %{provider: :google, extra: extra_data})
        |> get("/auth-callback")

      assert get_flash(conn, :error) === "Failed to authenticate."
      assert redirected_to(conn) === page_path(conn, :login)
      assert Guardian.Plug.current_resource(conn) === nil
    end

    test "failed auth doesn't sign user in", %{conn: conn} do
      conn =
        conn
        |> assign(:ueberauth_failure, %{})
        |> get("/auth-callback")

      assert get_flash(conn, :error) === "Failed to authenticate."
      assert redirected_to(conn) === page_path(conn, :login)
      assert Guardian.Plug.current_resource(conn) === nil
    end
  end

  describe "DELETE /auth" do
    alias Sejfguru.Accounts.User

    test "logs out the user" do
      conn = SejfguruWeb.Guardian.Plug.sign_in(build_conn(), %User{id: "1234"})
      assert Guardian.Plug.current_resource(conn) === %User{id: "1234"}

      conn = delete build_conn(), "/auth"
      assert Guardian.Plug.current_resource(conn) === nil
      assert redirected_to(conn) == "/login"
    end
  end
end
