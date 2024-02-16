defmodule SimonWeb.BundleLive.Index do
  use SimonWeb, :live_view

  alias Simon.Catalog.Category.Finders.{FindCategoryById, ListAllCategories}
  alias Simon.Catalog.Category.Service.DeleteCategory
  alias Simon.Catalog.Category

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :categories, ListAllCategories.run())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "세트 수정")
    |> assign(:category, FindCategoryById.run(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "새로운 세트")
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "세트 목록")
    |> assign(:category, nil)
  end

  @impl true
  def handle_info({SimonWeb.CategoryLive.FormComponent, {:saved, category}}, socket) do
    {:noreply, stream_insert(socket, :categories, category)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, category} = DeleteCategory.run(id)

    {:noreply, stream_delete(socket, :categories, category)}
  end
end
