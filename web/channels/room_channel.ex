defmodule Shopbird.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _auth_message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    {:reply, {:ok, %{body: body}}, socket}
  end

end
