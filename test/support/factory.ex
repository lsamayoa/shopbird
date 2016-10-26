defmodule Shopbird.Factory do
  use ExMachina.Ecto, repo: Shopbird.Repo

  alias Shopbird.User
  alias Shopbird.Product

  def user_factory do
    %User{
      first_name: "Bob",
      last_name: "Belcher",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def product_factory do
    %Product{
      description: "Hydrates your body.",
      name: "Water",
      price_cents: 42
    }
  end

end
