defmodule FreshService.ParserTest do
  use Sejfguru.DataCase
  import FreshService.Parser

  defmodule Asset do
    defstruct agent_id: nil
  end

  describe "parse/2" do
    test "decodes a successful response into a struct" do
      response = %{body: "{ \"agent_id\": \"some_id\" }", status_code: 200}
      assert {:ok, %Asset{agent_id: "some_id"}} == parse(response, Asset)
    end

    test "returns an error for 404 response" do
      response = %{body: "{ \"message\": \"Error message\" }", status_code: 400}
      assert {:error, %{"message" => "Error message"}, 400} == parse(response, Asset)
    end
  end

  describe "parse_list/2" do
    test "decodes a successful response into a list of structs" do
      json = """
      [
        {
          "agent_id": "1"
        },
        {
          "agent_id": "2"
        }
      ]
      """

      response = %{body: json, status_code: 200}
      expected = [%Asset{agent_id: "1"}, %Asset{agent_id: "2"}]

      assert {:ok, expected} == parse_list(response, Asset)
    end

    test "returns an error for 200 response that can't be decoded into struct" do
      response = %{body: "{ \"access_denied\": \"true\" }", status_code: 200}
      assert {:error, %{"access_denied" => "true"}, 200} == parse_list(response, Asset)
    end

    test "returns an error for 404 response" do
      response = %{body: "{ \"message\": \"Error message\" }", status_code: 400}
      assert {:error, %{"message" => "Error message"}, 400} == parse_list(response, Asset)
    end
  end
end
