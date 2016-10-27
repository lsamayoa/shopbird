defmodule Shopbird.User do
  require Logger
  use Shopbird.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Shopbird.Organization
  alias Shopbird.OrganizationUserMembership

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    many_to_many :organizations, Organization, join_through: OrganizationUserMembership

    timestamps()
  end

  @required_fields [:email, :password, :password_confirmation]
  @optional_fields [:first_name, :last_name]

  def changeset(user, params \\ %{}) do
    user
      |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(:create, user, params) do
    user
      |> changeset(params)
      |> validate_required(@required_fields)
      |> unique_constraint(:email)
      |> validate_length(:password, min: 1)
      |> validate_length(:password_confirmation, min: 1)
      |> validate_confirmation(:password)
      |> encrypt_password
  end

  def find_user_by_auth(%Ueberauth.Auth{provider: :identity} = auth) do
    Shopbird.User
      |> where(email: ^auth.info.email)
      |> first
  end

  defp encrypt_password(changeset) do
    put_change(changeset, :encrypted_password, hashpwsalt(changeset.params["password"]))
  end
end
