defmodule FreshService.AssetTest do
  use Sejfguru.DataCase
  import FreshService.Asset

  describe "all/1" do
    url = "https://sample.freshservice.com/cmdb/items.json?page="

    test "returns list of Asset structs from page 1" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [
          get!: fn("https://sample.freshservice.com/cmdb/items.json?page=1", _module) -> json_response([%{id: "1"}, %{id: "2"}], 200) end,
        ]}
      ]) do
        expected_response = {:ok, [
          %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: nil, created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "1", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil},
          %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: nil, created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "2", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil}
        ]}
        assert expected_response == all()
      end
    end

    test "returns list of Asset structs from given page" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [
          get!: fn("https://sample.freshservice.com/cmdb/items.json?page=2", _module) -> json_response([%{id: "3"}, %{id: "4"}], 200) end,
        ]}
      ]) do
        expected_response = {:ok, [
          %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: nil, created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "3", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil},
          %FreshService.Asset{agent_id: nil, agent_name: nil, asset_tag: nil, assigned_on: nil, business_impact: nil, ci_type_id: nil, ci_type_name: nil, created_at: nil, department_id: nil, department_name: nil, depreciation_id: nil, description: nil, display_id: nil, id: "4", impact: nil, levelfield_values: nil, location_id: nil, location_name: nil, name: nil, product_name: nil, salvage: nil, state_name: nil, updated_at: nil, usage_type: nil, used_by: nil, user_id: nil, vendor_name: nil}
        ]}
        assert expected_response == all(2)
      end
    end
  end
end
