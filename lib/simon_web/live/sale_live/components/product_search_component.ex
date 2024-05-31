defmodule SimonWeb.SaleLive.Components.ProductSearchComponent do
  @moduledoc false
  use SimonWeb, :live_component

  alias Simon.Catalog.Product.Finders.SearchProduct

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        :let={f}
        for={@product_search_form}
        id="product_search"
        phx-submit="search_product"
        phx-target={@myself}
        class="mb-2"
      >
        <label for="product_search" class="sr-only">상품 검색</label>
        <div class="relative">
          <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg
              class="w-5 h-5 text-gray-500 dark:text-gray-400"
              fill="currentColor"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
              >
              </path>
            </svg>
          </div>
          <input
            type="text"
            name={f[:product_search_query].name}
            id={f[:product_search_query].id}
            value={f[:product_search_query].value}
            class="block w-full p-2 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
            placeholder="상품 검색"
          />
        </div>
      </.form>
      <div
        :if={length(@products) > 0}
        id="products"
        class="px-4 overflow-y-auto sm:overflow-visible sm:px-0"
      >
        <table class="w-[40rem] mt-11 sm:w-full">
          <thead class="text-sm text-left leading-6 text-zinc-500">
            <tr>
              <th class="p-0 pb-4 pr-6 font-normal">코드</th>
              <th class="p-0 pb-4 pr-6 font-normal">이름</th>
              <th class="p-0 pb-4 pr-6 font-normal">가격</th>
              <th class="relative p-0 pb-4">
                <span class="sr-only">담기</span>
              </th>
            </tr>
          </thead>
          <tbody
            id="product_search_result_table"
            class="relative text-sm border-t divide-y divide-zinc-100 border-zinc-200 leading-6 text-zinc-700"
          >
            <tr
              :for={product <- @products}
              id={"search-product-#{product.id}"}
              phx-click="select_product"
              phx-value={product.id}
              class="group hover:bg-zinc-50"
            >
              <td class={["relative p-0", "hover:cursor-pointer"]}>
                <div class="block py-4 pr-6">
                  <span class="absolute right-0 -inset-y-px -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                  <span class={["relative", "font-semibold text-zinc-900"]}>
                    <%= product.code %>
                  </span>
                </div>
              </td>
              <td class={["relative p-0", "hover:cursor-pointer"]}>
                <div class="block py-4 pr-6">
                  <span class="absolute right-0 -inset-y-px -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                  <span class={["relative"]}><%= product.name %></span>
                </div>
              </td>
              <td class={["relative p-0", "hover:cursor-pointer"]}>
                <div class="block py-4 pr-6">
                  <span class="absolute right-0 -inset-y-px -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                  <span class={["relative"]}><%= product.price %></span>
                </div>
              </td>
              <td class="relative p-0 w-14">
                <div class="relative py-4 text-sm font-medium text-right whitespace-nowrap">
                  <span class="absolute left-0 -inset-y-px -right-4 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                  <span class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
                    <div>
                      <button phx-click="add_line" phx-value={product}>담기</button>
                    </div>
                  </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {
      :ok,
      socket
      |> assign(:product_search_form, %{})
      |> assign(:products, [])
    }
  end

  @impl true
  def handle_event("search_product", %{"product_search_query" => query}, socket) do
    results = SearchProduct.run(query)

    {:noreply, socket |> assign(:products, results)}
  end
end
