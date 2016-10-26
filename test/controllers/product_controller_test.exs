defmodule Shopbird.ProductControllerTest do
  use Shopbird.ConnCase
  import Shopbird.Factory

  alias Shopbird.Product
  @valid_attrs %{
    description: "Slides in snow for your mobility",
    name: "Skis",
    price_cents: 42
  }
  @invalid_attrs %{
    description: 42
  }

  setup do
    {:ok, %{user: insert(:user)}}
  end

  test "lists all entries on index", %{user: user} do
    conn = guardian_login(user)
    conn = get conn, product_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing products"
  end

  test "renders form for new resources", %{user: user} do
    conn = guardian_login(user)
    conn = get conn, product_path(conn, :new)
    assert html_response(conn, 200) =~ "New product"
  end

  test "creates resource and redirects when data is valid", %{user: user} do
    conn = guardian_login(user)
    conn = post conn, product_path(conn, :create), product: @valid_attrs
    assert redirected_to(conn) == product_path(conn, :index)
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{user: user} do
    conn = guardian_login(user)
    conn = post conn, product_path(conn, :create), product: @invalid_attrs
    assert html_response(conn, 200) =~ "New product"
  end

  test "shows chosen resource", %{user: user} do
    product = insert(:product)
    conn = guardian_login(user)
    conn = get conn, product_path(conn, :show, product)
    assert html_response(conn, 200) =~ "Show product"
  end

  test "renders page not found when id is nonexistent", %{user: user} do
    conn = guardian_login(user)
    assert_error_sent 404, fn ->
      get conn, product_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{user: user} do
    product = insert(:product)
    conn = guardian_login(user)
    conn = get conn, product_path(conn, :edit, product)
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "updates chosen resource and redirects when data is valid", %{user: user} do
    product = insert(:product)
    conn = guardian_login(user)
    conn = put conn, product_path(conn, :update, product), product: @valid_attrs
    assert redirected_to(conn) == product_path(conn, :show, product)
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{user: user} do
    product = insert(:product)
    conn = guardian_login(user)
    conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "deletes chosen resource", %{user: user} do
    product = insert(:product)
    conn = guardian_login(user)
    conn = delete conn, product_path(conn, :delete, product)
    assert redirected_to(conn) == product_path(conn, :index)
    refute Repo.get(Product, product.id)
  end
end
