defmodule Shopbird.OrganizationSpec do
  use ESpec.Phoenix, model: Organization, async: true
  alias Shopbird.Organization

  @valid_attrs %{name: "some content", owner_id: 1}
  @invalid_attrs %{}

  context "validation" do
    it "changeset with valid attributes" do
      changeset = Organization.changeset %Organization{}, @valid_attrs
      assert changeset.valid?
    end

    it "changeset with invalid attributes" do
      changeset = Organization.changeset(%Organization{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
