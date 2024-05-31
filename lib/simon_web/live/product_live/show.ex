defmodule SimonWeb.ProductLive.Show do
  use SimonWeb, :live_view

  alias Simon.Catalog.Product
  alias Simon.Catalog.Product.Finders.FindProductById

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    with {:ok, product = %Product{}} <- FindProductById.run(id) do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:product, product)}
    end
  end

  defp page_title(:show), do: "상품 조회"
  defp page_title(:edit), do: "상품 수정"
end
