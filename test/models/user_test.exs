defmodule Shopbird.UserTest do
  use Shopbird.ModelCase

  alias Shopbird.User

  @valid_attrs %{email: "test.user@email.com", first_name: "John", last_name: "Tester", password: "asdf1234", password_confirmation: "asdf1234"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
