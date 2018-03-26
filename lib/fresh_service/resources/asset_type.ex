defmodule FreshService.AssetType do
  @moduledoc """
  Represents an AssetType resource in the FreshService API.
  - [FreshService docs](https://api.freshservice.com/#get_all_ci_types)
  """

  import FreshService.Api, only: [get: 2]

  defstruct active: nil,
            ci_type_id: nil,
            deleted: nil,
            description: nil,
            id: nil,
            label: nil,
            name: nil,
            position: nil,
            required: nil

  def all(page \\ 1) do
    get("cmdb/ci_types.json?page=#{page}", __MODULE__)
  end

  def find(id) do
    get("cmdb/ci_types/#{id}.json", __MODULE__)
  end
end
