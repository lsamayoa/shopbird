defmodule Shopbird.OrganizationController do
  use Shopbird.Web, :controller
  require Logger

  alias Shopbird.Organization

  def new(conn, _params) do
    curret_user_id = conn.assigns[:current_user].id
    current_user_organization = Repo.get_by(Organization, owner_id: curret_user_id)
    if current_user_organization != nil,
      do: redirect(conn, to: organization_path(conn, :show, current_user_organization.id)),
      else: render(conn, "new.html", changeset: Organization.changeset(%Organization{}))
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
    organization = Organization.with_memberships
      |> Organization.with_owner
      |> Repo.get(id)
    conn
      |> assign(:organization, organization)
      |> _show()
  end

  defp _show(conn) do
    with {:ok, conn} <- _validate_organization_presence(conn),
         {:ok} <- _validate_organization_membership(conn),
       do: render(conn, "show.html"),
       else: ({:error, code, msg} -> _handle_error(conn, {:error, code, msg}))
  end

  defp _handle_error(conn, {:error, code, msg}), do: render(conn, Shopbird.ErrorView, "#{code}.html", error: msg)

  defp _validate_organization_presence(%{assigns: %{organization: nil}}), do: {:error, 404, gettext("Organization does not exist")}
  defp _validate_organization_presence(%{assigns: %{organization: _organization}} = conn), do: {:ok, conn}

  defp _validate_organization_membership(true), do: {:ok}
  defp _validate_organization_membership(false), do: {:error, 403, gettext("User does not have enough permissions")}
  defp _validate_organization_membership(nil), do: _validate_organization_membership(false)
  defp _validate_organization_membership(%{assigns: %{organization: %{id: organization_id}, current_user: %{id: user_id} }}) do
    _validate_organization_membership(Organization.validate_organization_membership(organization_id, user_id) |> Repo.one)
  end

end
