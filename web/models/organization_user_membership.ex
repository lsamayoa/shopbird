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
    |> cast(params, [:role, :user_id, :organization_id])
    |> cast_assoc(:user)
    |> cast_assoc(:organization)
    |> validate_required([:role, :user_id, :organization_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:organization_id, name: :organization_user_memberships_user_id_organization_id_index)
  end
end
