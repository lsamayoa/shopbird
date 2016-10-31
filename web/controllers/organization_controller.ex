defmodule Shopbird.OrganizationController do
  use Shopbird.Web, :controller
  require Logger

  alias Shopbird.Organization

  plug :_assign_current_user

  def new(conn, _params) do
    conn
      |> _assign_current_user_organization()
      |> case conn.assigns[:current_user_organization] do
        nil ->
          changeset = Organization.changeset(%Organization{})
          render(conn, "new.html", changeset: changeset)
      end
  end

  def create(conn, %{"organization" => organization_params}) do
    changeset = Organization.changeset(%Organization{owner_id: conn.assigns[:current_user].id}, organization_params)
    case Repo.insert(changeset) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, gettext("Organization created successfully."))
        |> redirect(to: organization_path(conn, :show, organization.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    conn
      |> _assign_organization(id)
      |> render("show.html")
  end

  defp _create_organization(conn, changeset) do

  end

  defp _assign_current_user(conn, _params) do
    assign conn, :current_user, Guardian.Plug.current_resource(conn)
  end

  defp _assign_organization(conn, id) do
    assign conn, :organization, Repo.get!(Organization, id)
  end

  defp _assign_current_user_organization(conn) do
    assign conn, :current_user_organization, Repo.get_by(Organization, owner_id: conn.assigns[:current_user].id)
  end

end
