defmodule Simon.Sale.Order.ShippingInfo do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "shipping_infos" do
    field :address, :string
    field :carrier, :string
    field :receiver, :string
    field :memo, :string

    belongs_to :order, Simon.Sale.Order

    timestamps()
  end

  def changeset(%__MODULE__{} = shipping_info, attrs \\ %{}) do
    shipping_info
    |> cast(attrs, [:shipping_date, :shipping_number, :shipping_cost, :shipping_memo, :order_id])
    |> validate_required([:shipping_date, :shipping_number, :shipping_cost, :order_id])
  end
end
