defmodule Sejfguru.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Sejfguru.Repo

  alias Sejfguru.Assets.Asset

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def list_assets do
    Repo.all(Asset)
  end

   @doc """
  Returns the list of assets of given type paginated.

  ## Examples

      iex> list_assets(type: "Mobile", page: 1)
      [%Asset{}, ...]

  """
  def list_assets(type: type, page: page) do
    Asset
    |> Ecto.Query.where(type_name: ^type)
    |> Ecto.Query.order_by(:name)
    |> Repo.paginate(page: page)
  end

   @doc """
  Returns the list of assets with users and bookings loaded, paginated.

  ## Examples

      iex> list_assets_with_users(page: 1)
      [%Asset{}, ...]

  """
  def list_assets_with_users(page: page) do
    Asset
    |> Ecto.Query.order_by(:name)
    |> Ecto.Query.preload(bookings: :user)
    |> Repo.paginate(page: page)
  end

   @doc """
  Returns the list of filtered assets with users and bookings loaded, paginated.

  ## Examples

      iex> filter_assets_with_users(query: "MacBook", page: 1)
      [%Asset{}, ...]

  """
  def filter_assets_with_users(query: query, page: page) do
    Asset
    |> Ecto.Query.where([a], like(a.name, ^"%#{query}%"))
    |> Ecto.Query.order_by(:name)
    |> Ecto.Query.preload(bookings: :user)
    |> Repo.paginate(page: page)
  end

   @doc """
  Returns the paginated list of assets.

  ## Examples

      iex> list_assets(page: 1)
      [%Asset{}, ...]

  """
  def list_assets(page: page) do
    Asset
      |> Ecto.Query.order_by(:name)
      |> Repo.paginate(page: page)
  end

  @doc """
  Gets a single asset.

  Raises `Ecto.NoResultsError` if the Asset does not exist.

  ## Examples

      iex> get_asset!(123)
      %Asset{}

      iex> get_asset!(456)
      ** (Ecto.NoResultsError)

  """
  def get_asset!(id), do: Repo.get!(Asset, id)

  @doc """
  Creates an asset.

  ## Examples

      iex> create_asset(%{name: "value"})
      {:ok, %Asset{}}

      iex> create_asset(%{name: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_asset(attrs \\ %{}) do
    %Asset{}
    |> Asset.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an asset.

  ## Examples

      iex> update_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> update_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_asset(%Asset{} = user, attrs) do
    user
    |> Asset.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates or updates an asset if it exists in the database

  ## Examples

      iex> upsert_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> upsert_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_asset(attrs \\ %{}) do
    %Asset{}
    |> Asset.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :freshservice_id)
  end

  @doc """
  Deletes an asset.

  ## Examples

      iex> delete_asset(asset)
      {:ok, %Asset{}}

      iex> delete_asset(asset)
      {:error, %Ecto.Changeset{}}

  """
  def delete_asset(%Asset{} = asset) do
    Repo.delete(asset)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking asset changes.

  ## Examples

      iex> change_asset(asset)
      %Ecto.Changeset{source: %Asset{}}

  """
  def change_asset(%Asset{} = asset) do
    Asset.changeset(asset, %{})
  end
end
