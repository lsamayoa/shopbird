defmodule Shopbird.OrganizationController do
  use Shopbird.Web, :controller
  require Logger

  alias Shopbird.Organization

  plug :_assign_current_user

  def new(conn, _params) do
    curret_user_id = conn.assigns[:current_user].id
    current_user_organization = Repo.get_by(Organization, owner_id: curret_user_id)
    if current_user_organization != nil,
      do: redirect(conn, to: organization_path(conn, :show, current_user_organization.id)),
      else: render(conn, "new.html", changeset: Organization.changeset(%Organization{}))
  end

  def create(conn, %{"organization" => organization_params}) do
    curret_user_id = conn.assigns[:current_user].id
    changeset = Organization.changeset(%Organization{owner_id: curret_user_id}, organization_params)
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
    conn = _assign_organization(conn, id)
    with {:ok} <- _validate_organization(conn),
         {:ok} <- _validate_organization_membership(conn),
       do: render(conn, "show.html"),
       else: ({:error, code, msg} -> _handle_error(conn, {:error, code, msg}))
  end

  defp _handle_error(conn, {:error, code, msg}), do: render(conn, Shopbird.ErrorView, "#{code}.html", error: msg)

  defp _assign_current_user(conn, _params), do: assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  defp _assign_organization(conn, organization_id), do: assign(conn, :organization, Repo.get(Organization, organization_id))

  defp _validate_organization(conn), do: (if conn.assigns[:organization] == nil, do: {:error, 404, gettext("Organization does not exist")}, else: {:ok})

  defp _validate_organization_membership(true), do: {:ok}
  defp _validate_organization_membership(nil), do: {:error, 403, gettext("User does not have enough permissions")}
  defp _validate_organization_membership(%Plug.Conn{} = conn), do: _validate_organization_membership(conn.assigns)
  defp _validate_organization_membership(%{} = %{:organization => %{:id => organization_id}, :current_user => %{:id => user_id} }) do
    _validate_organization_membership(Organization.check_organization_membership(organization_id, user_id) |> Repo.one)
  end


end
