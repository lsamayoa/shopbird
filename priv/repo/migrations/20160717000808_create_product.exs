defmodule Shopbird.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price_cents, :integer
      add :description, :string

      timestamps()
    end

  end
end
