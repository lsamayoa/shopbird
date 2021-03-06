defmodule Shopbird.ProductTest do
  use Shopbird.ModelCase

  alias Shopbird.Product

  @valid_attrs %{description: "some content", name: "some content", price_cents: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
