defmodule SimonWeb.PartyLive.Index do
  use SimonWeb, :live_view

  alias Simon.Relationship.Party
  alias Simon.Relationship.Finders.ListAllParties

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :parties, ListAllParties.run())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "거래처 등록")
    |> assign(:party, %Party{type: "organization"})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "거래처 관리")
    |> assign(:party, nil)
  end

  @impl true
  def handle_info({SimonWeb.PartyLive.FormComponent, {:saved, party}}, socket) do
    {:noreply, stream_insert(socket, :parties, party)}
  end
end
