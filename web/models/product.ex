defmodule Shopbird.Product do
  use Shopbird.Web, :model

  schema "products" do
    field :name, :string
    field :price_cents, :integer
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `product` and `params`.
  """
  def changeset(product, params \\ %{}) do
    product
    |> cast(params, [:name, :price_cents, :description])
    |> validate_required([:name, :price_cents, :description])
  end
end
