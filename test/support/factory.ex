defmodule Shopbird.Factory do
  use ExMachina.Ecto, repo: Shopbird.Repo

  alias Shopbird.User

  def user_factory do
    %User{
      first_name: "Bob",
      last_name: "Belcher",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

end
