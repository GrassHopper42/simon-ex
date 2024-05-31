defmodule SimonWeb.SaleLive.Components.LineList do
  @moduledoc false
  use SimonWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <.table
      id="line_table"
      rows={@lines || []}
      row_click={fn {_id, product} -> JS.navigate(~p"/products/#{product}") end}
    >
      <:col :let={{_id, product}} label="코드"><%= product.code %></:col>
      <:col :let={{_id, product}} label="이름"><%= product.name %></:col>
      <:col :let={{_id, product}} label="가격"><%= product.price %></:col>
      <:col :let={{_id, product}} label="카테고리"><%= product.category.name %></:col>
      <:action :let={{_id, product}}>
        <div class="sr-only">
          <.link navigate={~p"/products/#{product}"}>Show</.link>
        </div>
      </:action>
    </.table>
    """
  end
end
