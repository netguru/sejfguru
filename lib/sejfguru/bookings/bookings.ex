defmodule Sejfguru.Bookings do
  @moduledoc """
  The Bookings context.
  """

  import Ecto.Query, warn: false
  alias Sejfguru.Repo

  alias Sejfguru.Bookings.Booking

  @doc """
  Returns the list of bookings.

  ## Examples

      iex> list_bookings()
      [%Booking{}, ...]

  """
  def list_bookings do
    Repo.all(Booking)
  end

  @doc """
  Returns the list of bookings for given user.

  ## Examples

      iex> list_bookings_for_user(user)
      [%Booking{}, ...]

  """
  def list_bookings_for_user(user) do
    Booking
    |> where(user_id: ^user.id)
    |> Repo.all
    |> Repo.preload(:asset)
  end

  @doc """
  Returns the list of bookings for given asset.

  ## Examples

      iex> list_bookings_for_asset(asset)
      [%Booking{}, ...]

  """
  def list_bookings_for_asset(asset_id) do
    Booking
    |> order_by(:inserted_at)
    |> where(asset_id: ^asset_id)
    |> Repo.all
    |> Repo.preload([:user, :asset])
  end

  @doc """
  Gets a single booking.

  Raises `Ecto.NoResultsError` if the Booking does not exist.

  ## Examples

      iex> get_booking!(123)
      %Booking{}

      iex> get_booking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_booking!(id), do: Repo.get!(Booking, id)

  @doc """
  Creates a booking.

  ## Examples

      iex> create_booking(%{field: value})
      {:ok, %Booking{}}

      iex> create_booking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a booking.

  ## Examples

      iex> update_booking(booking, %{field: new_value})
      {:ok, %Booking{}}

      iex> update_booking(booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Creates or updates the booking if it exists in the database

  ## Examples

      iex> upsert_booking(booking, %{field: new_value})
      {:ok, %Booking{}}

      iex> upsert_booking(booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Booking.

  ## Examples

      iex> delete_booking(booking)
      {:ok, %Booking{}}

      iex> delete_booking(booking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking booking changes.

  ## Examples

      iex> change_booking(booking)
      %Ecto.Changeset{source: %Booking{}}

  """
  def change_booking(%Booking{} = booking) do
    Booking.changeset(booking, %{})
  end
end
