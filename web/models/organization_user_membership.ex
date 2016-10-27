defmodule Shopbird.OrganizationUserMembership do
  use Shopbird.Web, :model

  schema "organization_user_memberships" do
    field :role, :string
    belongs_to :user, Shopbird.User
    belongs_to :organization, Shopbird.Organization

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:role])
    |> validate_required([:role])
  end
end
