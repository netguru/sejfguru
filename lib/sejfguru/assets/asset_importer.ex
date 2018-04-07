defmodule Sejfguru.Assets.AssetImporter do
  def import do
    import_page(1)
  end

  defp import_page(page) do
    case import_assets(page) do
      {:ok} -> import_page(page + 1)
      {:error} -> {:error, "Freshservice assets import finished with error on page #{page}"}
      [] -> {:ok, "Freshservice assets imported successfully from #{page - 1} pages"}
    end
  end

  defp import_assets(page) do
    case fetch_assets(page) do
      [] ->
        []

      assets ->
        if Enum.all?(assets, fn asset -> insert_asset(asset) end), do: {:ok}, else: {:error}
    end
  end

  defp fetch_assets(page) do
    case FreshService.Asset.all(page) do
      {:ok, assets} -> assets
      _ -> []
    end
  end

  defp insert_asset(asset) do
    case asset |> format_attrs |> Sejfguru.Assets.upsert_asset() do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  defp format_attrs(asset) do
    %{
      department_name: asset.department_name,
      description: asset.description,
      freshservice_id: asset.display_id,
      location_name: asset.location_name,
      name: asset.name,
      product_name: asset.product_name,
      state_name: asset.state_name,
      tag: asset.asset_tag,
      type_name: asset.ci_type_name,
      used_by: asset.used_by,
      values: asset.levelfield_values,
      vendor_name: asset.vendor_name
    }
  end
end
