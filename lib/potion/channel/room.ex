defmodule Potion.Channel.Room do
  @moduledoc "Channel responsible for handling room events
  (sending messages, presence events)."

  use Phoenix.Channel
  alias Potion.Channel.Presence
  require Logger

  def join("room:" <> room_name, %{"nick" => nick_name}, socket) when is_binary(nick_name) do
    Logger.debug("User joining room #{room_name} with nick: #{nick_name}")

    send self, :after_join
    {:ok, assign(socket, :nick, nick_name)}
  end

  def join(_room, message, _socket) do
    Logger.warn("User failed to join room, #{inspect(message)}")
    {:error, %{reason: "Room doesn't exist or message is invalid."}}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    {:ok, _} = Presence.track socket, socket.assigns.nick,
      %{online_at: inspect(System.system_time(:seconds))}

    {:noreply, socket}
  end

  def handle_in("message", %{"content" => content}, socket) when is_binary(content) do
    broadcast! socket, "message",
      %{"content" => content, "sender" => socket.assigns.nick}

    {:noreply, socket}
  end

  def handle_in(name, body, socket) do
    Logger.warn(
      "Unmatched request with name \"#{name}\" with body #{inspect(body)}.")

    {:reply, {:error, %{reason: "Unmatched call."}}, socket}
  end
end
