defmodule Shopbird.RegistrationController do
  use Shopbird.Web, :controller

  def new(conn, _) do
    changeset = Shopbird.User.changeset(%Shopbird.User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    conn
      |> _create(Shopbird.User.changeset(:create, %Shopbird.User{}, user_params))
  end

  defp _create(conn, %{valid?: false} = changeset) do
    render conn, "new.html", changeset: changeset
  end

  defp _create(conn, %{valid?: true} = changeset) do
    new_user = changeset |> Shopbird.Repo.insert
    conn
      |> put_flash(:info, "Successfully registered and logged in")
      |> Guardian.Plug.sign_in(new_user)
      |> redirect(to: page_path(conn, :index))
  end

end
