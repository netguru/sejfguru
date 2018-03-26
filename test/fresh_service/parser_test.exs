defmodule FreshService.ParserTest do
  use Sejfguru.DataCase
  alias FreshService.TestAsset
  import FreshService.Parser
  doctest FreshService.Parser

  describe "parse/2" do
    test "decodes a successful response into a struct" do
      response = %{body: "{ \"id\": \"some_id\" }", status_code: 200}
      assert {:ok, %TestAsset{id: "some_id"}} == parse(response, TestAsset)
    end

    test "returns an error for 404 response" do
      response = %{body: "{ \"message\": \"Error message\" }", status_code: 400}
      assert {:error, %{"message" => "Error message"}, 400} == parse(response, TestAsset)
    end
  end

  describe "parse_list/2" do
    test "decodes a successful response into a list of structs" do
      json = """
      [
        {
          "id": "1"
        },
        {
          "id": "2"
        }
      ]
      """

      response = %{body: json, status_code: 200}
      expected = [%TestAsset{id: "1"}, %TestAsset{id: "2"}]

      assert {:ok, expected} == parse_list(response, TestAsset)
    end

    test "returns an error for 200 response that can't be decoded into struct" do
      response = %{body: "{ \"access_denied\": \"true\" }", status_code: 200}
      assert {:error, %{"access_denied" => "true"}, 200} == parse_list(response, TestAsset)
    end

    test "returns an error for 404 response" do
      response = %{body: "{ \"message\": \"Error message\" }", status_code: 400}
      assert {:error, %{"message" => "Error message"}, 400} == parse_list(response, TestAsset)
    end
  end
end
