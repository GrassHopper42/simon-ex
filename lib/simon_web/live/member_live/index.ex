defmodule SimonWeb.MemberLive.Index do
  use SimonWeb, :live_view

  alias Simon.HumanResources.Member
  alias Simon.HumanResources.Finders.ListAllMembers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :members, ListAllMembers.run())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "직원 등록")
    |> assign(:member, %Member{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "직원 관리")
    |> assign(:member, nil)
  end

  @impl true
  def handle_info({SimonWeb.MemberLive.FormComponent, {:saved, member}}, socket) do
    {:noreply, stream_insert(socket, :members, member)}
  end
end
