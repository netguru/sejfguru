defmodule FreshService.AssetTypeTest do
  use Sejfguru.DataCase
  import FreshService.AssetType

  describe "all/1" do
    test "returns list of AssetType structs from page 1" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [
          get!: fn("https://sample.freshservice.com/cmdb/ci_types.json?page=1", _module) -> json_response([%{id: "1", ci_type_id: "1"}, %{id: "2", ci_type_id: "2"}], 200) end,
        ]}
      ]) do
        expected_response = {:ok, [
          %FreshService.AssetType{active: nil, ci_type_id: "1", deleted: nil, description: nil, id: "1", label: nil, name: nil, position: nil, required: nil},
          %FreshService.AssetType{active: nil, ci_type_id: "2", deleted: nil, description: nil, id: "2", label: nil, name: nil, position: nil, required: nil}
        ]}
        assert expected_response == all()
      end
    end

    test "returns list of AssetType structs from given page" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [
          get!: fn("https://sample.freshservice.com/cmdb/ci_types.json?page=3", _module) -> json_response([%{id: "5", ci_type_id: "5"}, %{id: "6", ci_type_id: "6"}], 200) end,
        ]}
      ]) do
        expected_response = {:ok, [
          %FreshService.AssetType{active: nil, ci_type_id: "5", deleted: nil, description: nil, id: "5", label: nil, name: nil, position: nil, required: nil},
          %FreshService.AssetType{active: nil, ci_type_id: "6", deleted: nil, description: nil, id: "6", label: nil, name: nil, position: nil, required: nil}
        ]}
        assert expected_response == all(3)
      end
    end
  end

    describe "find/1" do
    test "returns AssetType struct with given id" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [
          get!: fn("https://sample.freshservice.com/cmdb/ci_types/1.json", _module) -> json_response([%{id: "1", ci_type_id: "1"}], 200) end,
        ]}
      ]) do
        expected_response = {:ok, [
          %FreshService.AssetType{active: nil, ci_type_id: "1", deleted: nil, description: nil, id: "1", label: nil, name: nil, position: nil, required: nil}
        ]}
        assert expected_response == find(1)
      end
    end
  end
end
