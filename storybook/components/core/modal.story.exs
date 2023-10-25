defmodule Storybook.Components.Core.Button do
  use PhoenixStorybook.Story, :component
  alias Elixir.SimonWeb.Core.Modal
  alias Elixir.SimonWeb.CoreComponents

  def function, do: &Modal.modal/1

  def imports,
    do: [
      {CoreComponents, [button: 1]},
      {Modal, [hide_modal: 1, show_modal: 1]}
    ]

  def template do
    """
    <.button phx-click={show_modal(":variation_id")} lsb-code-hidden>
      Open modal
    </.button>
    <.lsb-variation/>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        slots: ["Modal body"]
      },
      %Variation{
        id: :with_header,
        slots: [
          "<:header>Header</:header>",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        ]
      },
      %Variation{
        id: :with_footer,
        slots: [
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
          "<:footer>Footer</:footer>"
        ]
      }
    ]
  end
end
