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

      asset_response = {:ok, [
        %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: "Laptop", created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "1", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil},
        %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: "Phone", created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "2", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil}
      ]}

      with_mock FreshService.Asset, [all: fn(_page) -> asset_response end] do
        conn =
          conn
          |> Guardian.Plug.sign_in(user)
          |> get(asset_path(conn, :index))

        assert html_response(conn, 200) =~ "Hello, John"
        assert html_response(conn, 200) =~ "Laptop"
        assert html_response(conn, 200) =~ "Phone"
      end
    end

    test "requires user to be sign in", %{conn: conn} do
      conn = get(conn, asset_path(conn, :index))

      assert redirected_to(conn) === page_path(conn, :login)
      assert get_flash(conn, :error) === "unauthenticated"
    end
  end
end
