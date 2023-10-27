defmodule SimonWeb.ProductLive.FormComponent do
  use SimonWeb, :live_component

  alias Ecto
  alias Simon.Catalog.Product
  alias Simon.Catalog.Category.Finders.ListAllCategories
  alias Simon.Catalog.Product.Service.UpdateProductDetail

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.form
        :let={f}
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="mb-4 grid gap-4 sm:grid-cols-2">
          <.input
            field={f[:category_id]}
            type="select"
            label="카테고리"
            prompt="카테고리를 선택하세요"
            options={ListAllCategories.run() |> Enum.map(&{&1.name, &1.id})}
          />
          <.input field={f[:code]} type="text" label="가격" />
          <.input field={f[:name]} type="text" label="이름" />
          <.input field={f[:price]} type="number" label="가격" />
          <.inputs_for :let={detail} field={f[:detail]}>
            <.input field={detail[:standard]} type="text" label="규격" />
            <.input field={detail[:description]} type="textarea" label="설명" />
          </.inputs_for>
        </div>
        <.button phx-disable-with="Saving...">등록</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Product.update_changeset(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Product.update_changeset(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case UpdateProductDetail.run(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
