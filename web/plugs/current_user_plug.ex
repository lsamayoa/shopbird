defmodule Shopbird.CurrentUserPlug do
  import Plug.Conn

  def init(opts \\ %{}), do: Enum.into(opts, %{})
  def call(conn, _params), do: assign(conn, :current_user, Guardian.Plug.current_resource(conn))
end
