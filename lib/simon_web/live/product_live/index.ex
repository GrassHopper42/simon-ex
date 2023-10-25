defmodule SimonWeb.ProductLive.Index do
  use SimonWeb, :live_view

  alias Simon.Catalog.Product.Finders.{ListAllProducts, FindProductById}
  alias Simon.Catalog.Product.Service.DeleteProduct
  alias Simon.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products, ListAllProducts.run())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, FindProductById.run!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({SimonWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info({SimonWeb.ProductLive.RegistrationForm, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, product} = DeleteProduct.run(id)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
