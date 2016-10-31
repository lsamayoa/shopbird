defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias Shopbird.Repo
    end
  end

  def controller do
    quote do
      alias Shopbird
      alias Shopbird.Repo
      import Shopbird.Router.Helpers

      @endpoint Shopbird.Endpoint

      # We need a way to get into the connection to login a user
      # We need to use the bypass_through to fire the plugs in the router
      # and get the session fetched.
      def guardian_login(%Shopbird.User{} = user), do: guardian_login(build_conn(), user, :token, [])
      def guardian_login(%Shopbird.User{} = user, token), do: guardian_login(build_conn(), user, token, [])
      def guardian_login(%Shopbird.User{} = user, token, opts), do: guardian_login(build_conn(), user, token, opts)

      def guardian_login(%Plug.Conn{} = conn, user), do: guardian_login(conn, user, :token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token), do: guardian_login(conn, user, token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
        conn
          |> bypass_through(Shopbird.Router, [:browser])
          |> get("/")
          |> Guardian.Plug.sign_in(user, token, opts)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
      end
    end
  end

  def view do
    quote do
      import Shopbird.Router.Helpers
    end
  end

  def channel do
    quote do
      alias Shopbird.Repo

      @endpoint Shopbird.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
