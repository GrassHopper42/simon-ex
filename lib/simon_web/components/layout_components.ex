defmodule SimonWeb.LayoutComponents do
  @moduledoc """
  LayoutComponents
  """
  use SimonWeb, :html

  slot :inner_block, required: true

  def app_shell(assigns) do
    ~H"""
    <.navbar class="fixed top-0 left-0 right-0 z-50"></.navbar>
    <main class="h-auto p-4 pt-20">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  slot :inner_block

  attr :class, :string, default: nil

  defp navbar(assigns) do
    ~H"""
    <nav class="bg-white border-b border-gray-200 px-4 py-2.5 dark:bg-gray-800 dark:border-gray-700">
      <div class="flex flex-wrap items-center justify-between p-4 max-w-auto">
        <div class="flex items-center justify-start">
          <.logo />
        </div>
        <ul class="flex flex-col p-4 mt-4 font-medium border border-gray-100 rounded-lg md:p-0 bg-gray-50 md:flex-row md:space-x-8 md:mt-0 md:border-0 md:bg-white dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700">
          <.navbar_item link={~p"/products"}>상품 관리</.navbar_item>
          <.navbar_item link={~p"/"}>창고 관리</.navbar_item>
          <.navbar_item link={~p"/"}>판매 관리</.navbar_item>
        </ul>
        <div class="flex items-center lg:order-2">
          <.notifications />
        </div>
      </div>
    </nav>
    """
  end

  slot :inner_block, required: true
  attr :link, :string, required: true

  defp navbar_item(assigns) do
    ~H"""
    <li>
      <.link
        patch={@link}
        class="block py-2 pl-3 pr-4 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent"
        aria-current="page"
      >
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end

  slot :menu, required: false do
    attr :href, :string, required: true
  end

  attr :class, :string, default: nil

  defp logo(assigns) do
    ~H"""
    <.link navigate={~p"/"} class="flex items-center justify-between mr-4">
      <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">
        Simon
      </span>
    </.link>
    """
  end

  defp notifications(assigns) do
    ~H"""
    <button
      type="button"
      data-dropdown-toggle="notification-dropdown"
      class="p-2 mr-1 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700 focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
    >
      <span class="sr-only">View notifications</span>
      <!-- Bell icon -->
      <svg
        aria-hidden="true"
        class="w-6 h-6"
        fill="currentColor"
        viewBox="0 0 20 20"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z">
        </path>
      </svg>
    </button>
    <.notification_dropdown />
    """
  end

  defp notification_dropdown(assigns) do
    ~H"""
    <div
      class="z-50 hidden max-w-sm my-4 overflow-hidden text-base list-none bg-white rounded shadow-lg divide-y divide-gray-100 dark:divide-gray-600 dark:bg-gray-700"
      id="notification-dropdown"
    >
      <div class="block px-4 py-2 text-base font-medium text-center text-gray-700 bg-gray-50 dark:bg-gray-600 dark:text-gray-300">
        Notifications
      </div>
    </div>
    """
  end
end
