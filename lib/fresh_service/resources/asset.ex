defmodule FreshService.Asset do
  @moduledoc """
  Represents an Asset resource in the FreshService API.
  - [FreshService docs](http://api.freshservice.com/#asset)
  """

  import FreshService.Api, only: [get: 2]

  defstruct agent_id: nil,
            agent_name: nil,
            asset_tag: nil,
            assigned_on: nil,
            business_impact: nil,
            ci_type_id: nil,
            ci_type_name: nil,
            created_at: nil,
            department_id: nil,
            department_name: nil,
            depreciation_id: nil,
            description: nil,
            display_id: nil,
            id: nil,
            impact: nil,
            levelfield_values: nil,
            location_id: nil,
            location_name: nil,
            name: nil,
            product_name: nil,
            salvage: nil,
            state_name: nil,
            updated_at: nil,
            usage_type: nil,
            used_by: nil,
            user_id: nil,
            vendor_name: nil

  def all(page \\ 1) do
    get("cmdb/items.json?page=#{page}", __MODULE__)
  end

  def find(display_id) do
    get("cmdb/items/#{display_id}.json", __MODULE__)
  end
end
