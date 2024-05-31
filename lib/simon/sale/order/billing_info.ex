defmodule Simon.Sale.Order.BillingInfo do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_infos" do
    field :type, Ecto.Enum, values: [:credit_card, :bank_transfer, :cash], default: :credit_card
    field :card_number, :string
    field :card_holder, :string
    field :card_expiration, :string
    field :bank_account, :string
    field :bank_holder, :string
    field :bank_name, :string
    field :bank_branch, :string
    field :bank_swift, :string
    field :cash_receipt, :string
    field :cash_date, :date
    field :cash_receipt_number, :string
    field :memo, :string

    belongs_to :order, Simon.Sale.Order

    timestamps()
  end
end
