defmodule FreshService.ApiTest do
  use Sejfguru.DataCase
  alias FreshService.TestAsset
  import FreshService.Api
  doctest FreshService.Api

  describe "get/2" do
    test "returns parsed response (with struct) from given path" do
      with_mocks([
        {FreshService.Config, [], [
          domain: fn() -> "sample" end,
          username: fn() -> "user" end,
          password: fn() -> "secret" end
        ]},
        {FreshService.Api, [:passthrough], [get!: fn(_url, _headers) -> json_response([%{id: "id"}], 200) end]}
      ]) do
        assert {:ok, [%TestAsset{id: "id"}]} == get("/test.json", TestAsset)
      end
    end
  end

  describe "build_url/1" do
    test "returns url build with domain from Config and path from argument" do
      with_mock FreshService.Config, [domain: fn() -> "sample" end] do
        path = "/test.json"
        assert "https://sample.freshservice.com//test.json" == build_url(path)
      end
    end
  end

  describe "auth_header/2" do
    test "returns headers if Authorization headers given" do
      headers = ["Authorization": "Basic BASE64=="]
      assert headers == auth_header(headers, %{})
    end

    test "returns headers if headers are not a list" do
      headers = ["Authorization: Basic BASE64=="]
      assert headers == auth_header(headers, %{})
    end

    test "returns encoded credential headers if credentials given" do
      headers = []
      credentials = {:username, :password}
      assert [{:Authorization, "Basic dXNlcm5hbWU6cGFzc3dvcmQ="}] == auth_header(headers, credentials)
    end

    test "returns encoded credential headers if credentials given along with existing headers" do
      headers = ["Content-Type": "application/json"]
      credentials = {:username, :password}
      assert ["Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=", "Content-Type": "application/json"] == auth_header(headers, credentials)
    end
  end

  describe "auth_header/1" do
    test "returns headers if Authorization headers given" do
      options = %{username: :username, password: :password}
      assert ["Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ="] == auth_header(options)
    end
  end
end
