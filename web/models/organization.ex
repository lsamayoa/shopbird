defmodule Shopbird.Organization do
  use Shopbird.Web, :model

  alias Shopbird.User
  alias Shopbird.OrganizationUserMembership

  schema "organizations" do
    field :name, :string
    belongs_to :owner, User

    many_to_many :members, User, join_through: OrganizationUserMembership
    has_many :memberships, OrganizationUserMembership
    timestamps()
  end

  ## Changesets

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :owner_id])
    |> cast_assoc(:owner)
    |> validate_required([:name])
    |> validate_required(:owner_id, message: "Owner can't be blank")
    |> unique_constraint(:owner_id, message: "A user cannot own more than 1 organization")
    |> foreign_key_constraint(:owner_id, message: "A valid owner must be set for the organization")
  end

  ## Queries

  def with_owner(), do: with_owner(Shopbird.Organization)
  def with_owner(query), do: from(q in query, preload: :owner)

  def with_memberships(), do: with_memberships(Shopbird.Organization)
  def with_memberships(query), do: from(q in query, preload: [memberships: :user])

  def validate_organization_membership(organization_id, user_id) do
    from o in Shopbird.Organization,
      left_join: oum in OrganizationUserMembership, on: oum.organization_id == o.id,
      where: o.id == ^organization_id and (o.owner_id == ^user_id or oum.user_id == ^user_id),
      select: count(o.id) == 1
  end

end
