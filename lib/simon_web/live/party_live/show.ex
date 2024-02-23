defmodule SimonWeb.PartyLive.Show do
  use SimonWeb, :live_view

  alias Simon.Relationship.Party
  alias Simon.Relationship.Finders.FindPartyById

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    with {:ok, party = %Party{}} <- FindPartyById.run(id) do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:party, party)}
    end
  end

  defp page_title(:show), do: "Show Party"
  defp page_title(:edit), do: "Edit Party"
end
