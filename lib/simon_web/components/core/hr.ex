defmodule SimonWeb.Core.Hr do
  @moduledoc false
  use Phoenix.Component

  def hr_default(assigns) do
    ~H"""
    <hr class="h-px my-8 bg-gray-200 border-0 dark:bg-gray-700" />
    """
  end

  slot :inner_block, required: true

  def hr_with_text(assigns) do
    ~H"""
    <div class="inline-flex items-center justify-center w-full">
      <hr class="w-64 h-px my-8 bg-gray-200 border-0 dark:bg-gray-700" />
      <span class="absolute px-3 font-medium text-gray-900 bg-white -translate-x-1/2 left-1/2 dark:text-white dark:bg-gray-900">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end
end
