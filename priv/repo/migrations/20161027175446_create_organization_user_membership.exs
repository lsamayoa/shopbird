defmodule Shopbird.Repo.Migrations.CreateOrganizationUserMembership do
  use Ecto.Migration

  def change do
    create table(:organization_user_memberships) do
      add :role, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)

      timestamps()
    end
    create index(:organization_user_memberships, [:user_id])
    create index(:organization_user_memberships, [:organization_id])

  end
end
