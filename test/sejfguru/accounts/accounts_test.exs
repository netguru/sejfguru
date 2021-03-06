defmodule Sejfguru.AccountsTest do
  use Sejfguru.DataCase

  alias Sejfguru.Accounts

  describe "users" do
    alias Sejfguru.Accounts.User

    @valid_attrs %{email: "some email", google_uid: "some google_uid", image: "some image"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", google_uid: "some updated google_uid", image: "some updated image", last_name: "some updated last_name"}
    @invalid_attrs %{email: nil, google_uid: nil, image: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      attrs_with_names = Map.merge(
        @valid_attrs,
        %{first_name: "some first_name", last_name: "some last_name"}
      )

      assert {:ok, %User{} = user} = Accounts.create_user(attrs_with_names)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.google_uid == "some google_uid"
      assert user.image == "some image"
    end

    test "create_user/1 allows empty first_name and last_name" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.google_uid == "some updated google_uid"
      assert user.image == "some updated image"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
