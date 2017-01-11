defmodule Shopbird.Repo.Migrations.AddOrganizationToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :organization_id, references(:organizations, on_delete: :delete_all)
    end
  end

end
