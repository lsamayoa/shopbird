defmodule Shopbird.Organization do
  use Shopbird.Web, :model

  alias Shopbird.User
  alias Shopbird.OrganizationUserMembership

  schema "organizations" do
    field :name, :string
    belongs_to :owner, User

    many_to_many :members, User, join_through: OrganizationUserMembership

    timestamps()
  end

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

end
