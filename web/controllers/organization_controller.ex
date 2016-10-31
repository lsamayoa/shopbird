defmodule Shopbird.OrganizationController do
  use Shopbird.Web, :controller
  require Logger

  alias Shopbird.Organization

  plug :_assign_current_user

  def new(conn, _params) do
    current_user_organization = Repo.get_by(Organization, owner_id: conn.assigns[:current_user].id)
    if current_user_organization != nil,
      do: redirect(conn, to: organization_path(conn, :show, current_user_organization.id)),
      else: render(conn, "new.html", changeset: Organization.changeset(%Organization{}))
  end

  def create(conn, %{"organization" => organization_params}) do
    changeset = Organization.changeset(%Organization{owner_id: conn.assigns[:current_user].id}, organization_params)
    conn
      |> _create_organization(changeset)
  end

  def show(conn, %{"id" => id}) do
    conn = _assign_organization(conn, id)
    case _validate_show(conn) do
      {:ok} -> render(conn, "show.html")
      {:error, code, _msg} -> render(conn, Shopbird.ErrorView, "#{code}.html")
    end
  end

  defp _create_organization(conn, changeset) do
    case Repo.insert(changeset) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, gettext("Organization created successfully."))
        |> redirect(to: organization_path(conn, :show, organization.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp _assign_current_user(conn, _params), do: assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  defp _assign_organization(conn, organization_id), do: assign(conn, :organization, Repo.get(Organization, organization_id))

  defp _validate_show(conn) do
    case _validate_organization(conn) do
      {:ok} -> _validate_organization_membership(conn)
      {:error, code, msg} -> {:error, code, msg}
    end
  end

  defp _validate_organization(conn) do
    if conn.assigns[:organization] == nil,
      do: {:error, 404, "Organization does not exist"},
      else: {:ok}
  end

  defp _validate_organization_membership(conn) do
    user_id = conn.assigns[:current_user].id
    org_id = conn.assigns[:organization].id
    membership_check = Organization.check_organization_membership(org_id, user_id) |> Repo.one
    if !membership_check,
      do: {:error, 403, "User does not have enough permissions"},
      else: {:ok}
  end

end
