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
    |> assoc_constraint(:owner)
    |> validate_required([:name, :owner_id])
  end

end
