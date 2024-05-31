defmodule SimonWeb.SaleLive.Index do
  alias Simon.Relationship.Finders.FindPartyById
  use SimonWeb, :live_view

  alias Simon.Sale.Order

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:orders, []),
      layout: false
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("select_product", _params, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "주문 관리")
    |> assign(:orderer, nil)
  end

  defp apply_action(socket, :show_orderer, %{"orderer_id" => id}) do
    socket
    |> assign(:page_title, "주문 관리")
    |> assign(:orderer, FindPartyById.run(id))
  end

  defp apply_action(socket, :new, %{"orderer_id" => id}) do
    orderer =
      if Map.has_key?(socket.assigns, :orderer),
        do: socket.assigns.orderer,
        else: FindPartyById.run(id)

    socket
    |> assign(:page_title, "새 견적")
    |> assign(:orderer, orderer)
    |> assign(:order, %Order{
      orderer: orderer,
      pic: socket.assigns.current_member
    })
  end
end
