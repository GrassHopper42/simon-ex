defmodule SimonWeb.SaleLive.Components.OrdererComponent do
  @moduledoc false
  use SimonWeb, :live_component

  alias Simon.Relationship.Finders.ListAllParties
  alias Simon.Relationship.Finders.SearchParty
  alias Simon.Relationship.Finders.FindPartyById

  @impl true
  def render(assigns) do
    ~H"""
    <aside
      class="fixed top-0 left-0 z-40 w-64 h-screen bg-white border-r border-gray-200 transition-transform -translate-x-full md:translate-x-0 dark:bg-gray-800 dark:border-gray-700"
      aria-label="Sidenav"
      id="drawer-navigation"
    >
      <div class="h-full px-3 py-5 overflow-y-auto bg-white dark:bg-gray-800">
        <%= if @orderer == nil do %>
          <.form
            :let={f}
            for={@party_search_form}
            id="party_search"
            phx-submit="search_party"
            phx-target={@myself}
            class="mb-2"
          >
            <label for="party_search" class="sr-only">거래처 검색</label>
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
                name={f[:party_search_query].name}
                id={f[:party_search_query].id}
                value={f[:party_search_query].value}
                class="block w-full p-2 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                placeholder="거래처 검색"
              />
            </div>
          </.form>
          <ul>
            <%= for party <- @parties do %>
              <li id={"party_#{party.id}"}>
                <.link patch={~p"/sale/#{party}"}>
                  <%= party.name %>
                </.link>
              </li>
            <% end %>
          </ul>
        <% else %>
          <.link patch={~p"/sale"}>
            <svg
              class="w-6 h-6 text-gray-800 dark:text-white"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="none"
              viewBox="0 0 24 24"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="m15 19-7-7 7-7"
              />
            </svg>
          </.link>
          <div>
            <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
              <%= @orderer.name %>
            </h5>
            <p class="font-normal text-gray-700 dark:text-gray-400">
              <%= @orderer.address %>
            </p>
          </div>
        <% end %>
      </div>
    </aside>
    """
  end

  @impl true
  def mount(socket) do
    {
      :ok,
      socket
      |> assign(:parties, ListAllParties.run())
      |> assign(:party_search_form, to_form(%{}))
    }
  end

  @impl true
  def handle_event("search_party", %{"party_search_query" => query}, socket) do
    {
      :noreply,
      socket
      |> assign(:parties, SearchParty.run(query))
    }
  end

  @impl true
  def handle_event("select_party", %{"id" => id}, socket) do
    orderer = FindPartyById.run(id)

    {:noreply, socket |> assign(:orderer, orderer)}
  end
end
