defmodule Shopbird.AuthController do
  use Shopbird.Web, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
      |> put_flash(:info, "You have been logged out!")
      |> configure_session(drop: true)
      |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
      |> put_flash(:error, "Failed to authenticate.")
      |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: %{provider: :identity} = auth}} = conn, _params) do
    user = auth |> _get_user_by_auth
    case _check_password(user, auth.credentials.other.password) do
      true -> conn |> _authenticate(user)
      _    -> conn |> _authenticate(nil)
    end
  end

  def callback(conn, _params) do
    conn
      |> put_flash(:error, "Failed to authenticate.")
      |> redirect(to: "/")
  end

  def unauthenticated(conn, _params) do
    conn
      # |> put_status(401)
      |> put_flash(:error, "Authentication required")
      |> redirect(to: "/")
  end

  defp _get_user_by_auth(auth), do: Shopbird.User.find_user_by_auth(auth) |> Repo.one

  defp _check_password(user, password) when not is_nil(user), do: checkpw(password, user.encrypted_password)
  defp _check_password(_, _), do: false

  defp _authenticate(conn, user) when not is_nil(user) do
    conn
      |> put_flash(:info, "Successfully authenticated.")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/")
  end

  defp _authenticate(conn, _) do
    conn
      |> put_flash(:error, "Failed to authenticate.")
      |> redirect(to: "/")
  end

end
