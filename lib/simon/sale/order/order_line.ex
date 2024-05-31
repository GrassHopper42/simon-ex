defmodule Simon.Sale.Order.OrderLine do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "order_lines" do
    field :product_name, :string
    field :quantity, :integer
    field :unit_price, :integer
    field :amount, :integer
    field :memo, :string

    belongs_to :order, Simon.Sale.Order
    belongs_to :product, Simon.Catalog.Product

    timestamps()
  end

  def changeset(%__MODULE__{} = order_line, attrs \\ %{}) do
    order_line
    |> cast(attrs, [:product_name, :quantity, :unit_price, :amount, :order_id, :product_id])
    |> validate_required([:product_name, :quantity, :unit_price, :amount, :order_id, :product_id])
  end
end
