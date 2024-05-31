defmodule Simon.Sale.Order do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Simon.Sale.Order.OrderLine
  alias Simon.Sale.Order.ShippingInfo
  alias Simon.Sale.Order.BillingInfo

  schema "orders" do
    field :status, Ecto.Enum, values: [:ordered, :shipped, :delivered], default: :ordered
    field :ordered_at, :naive_datetime
    field :order_number, :string
    field :total_amount, :integer
    field :total_quantity, :integer
    field :memo, :string

    belongs_to :orderer, Simon.Relationship.Party, foreign_key: :orderer_id
    belongs_to :pic, Simon.HumanResources.Member, foreign_key: :pic_id

    has_many :order_lines, OrderLine, on_delete: :delete_all
    has_many :quotations, Simon.Sale.Quotation, foreign_key: :order_id

    has_one :shipping_info, ShippingInfo, on_delete: :delete_all
    has_one :billing_info, BillingInfo, on_delete: :delete_all

    timestamps()
  end

  def changeset(%__MODULE__{} = order, attrs \\ %{}) do
    order
    |> cast(attrs, [:orderer_id, :pic_id])
    |> cast_assoc(:order_lines)
    |> cast_assoc(:shipping_info)
    |> cast_assoc(:billing_info)
    |> calculate_total_amount()
    |> calculate_total_quantity()
  end

  defp calculate_total_amount(changeset) do
    total_amount =
      changeset
      |> get_assoc(:order_lines, :struct)
      |> Enum.reduce(0, fn line, acc -> acc + line.amount end)

    changeset
    |> put_change(:total_amount, total_amount)
  end

  defp calculate_total_quantity(changeset) do
    total_quantity =
      changeset
      |> get_assoc(:order_lines, :struct)
      |> Enum.reduce(0, fn line, acc -> acc + line.quantity end)

    changeset
    |> put_change(:total_quantity, total_quantity)
  end
end
