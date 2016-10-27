defmodule Shopbird.OrganizationUserMembershipTest do
  use Shopbird.ModelCase

  alias Shopbird.OrganizationUserMembership

  @valid_attrs %{role: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = OrganizationUserMembership.changeset(%OrganizationUserMembership{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OrganizationUserMembership.changeset(%OrganizationUserMembership{}, @invalid_attrs)
    refute changeset.valid?
  end
end
