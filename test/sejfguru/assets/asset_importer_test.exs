defmodule Sejfguru.Assets.AssetImporterTest do
  use Sejfguru.DataCase
  alias Sejfguru.Assets.AssetImporter

  describe "import/0" do
    test "with no assets returned from API" do
      with_mocks([
        {FreshService.Asset, [], [all: fn(i) -> if i==1, do: [] end]},
      ]) do
        assert {:ok, "Freshservice assets imported successfully from 0 pages"} == AssetImporter.import()
      end
    end

    test "with 1 page of assets returned from API" do
      with_mocks([
        {FreshService.Asset, [], [
          all: fn(i) ->
            case i do
              1 -> {:ok, [%FreshService.Asset{name: "device1", display_id: 1}, %FreshService.Asset{name: "device2", display_id: 2}]}
              2 -> []
            end
          end,
        ]},
      ]) do
        assert {:ok, "Freshservice assets imported successfully from 1 pages"} == AssetImporter.import()
        assert length(Sejfguru.Repo.all(Sejfguru.Assets.Asset)) == 2
      end
    end

    test "with 2 page of assets returned from API" do
      with_mocks([
        {FreshService.Asset, [], [
          all: fn(i) ->
            case i do
              1 -> {:ok, [%FreshService.Asset{name: "device1", display_id: 1}, %FreshService.Asset{name: "device2", display_id: 2}]}
              2 -> {:ok, [%FreshService.Asset{name: "device3", display_id: 3}, %FreshService.Asset{name: "device4", display_id: 4}]}
              3 -> []
            end
          end,
        ]},
      ]) do
        assert {:ok, "Freshservice assets imported successfully from 2 pages"} == AssetImporter.import()
        assert length(Sejfguru.Repo.all(Sejfguru.Assets.Asset)) == 4
      end
    end

    test "asset insert returned error" do
      with_mocks([
        {FreshService.Asset, [], [
          all: fn(i) ->
            case i do
              1 -> {:ok, [%FreshService.Asset{name: "device1", display_id: 1}, %FreshService.Asset{name: "device2", display_id: 2}]}
              2 -> {:ok, [%FreshService.Asset{name: "device3", display_id: 3}, %FreshService.Asset{name: "device4", display_id: 4}]}
              3 -> []
            end
          end,
        ]},
        {Sejfguru.Assets, [], [
          upsert_asset: fn(attrs) ->
            case attrs.freshservice_id do
              1 ->
                %Sejfguru.Assets.Asset{}
                  |> Sejfguru.Assets.Asset.changeset(attrs)
                  |> Sejfguru.Repo.insert(on_conflict: :replace_all, conflict_target: :freshservice_id)
              _ ->
                {:error, %{}}
            end
          end
        ]},
      ]) do
        assert {:error, "Freshservice assets import finished with error on page 1"} == AssetImporter.import()
        assert length(Sejfguru.Repo.all(Sejfguru.Assets.Asset)) == 1
      end
    end
  end
end
