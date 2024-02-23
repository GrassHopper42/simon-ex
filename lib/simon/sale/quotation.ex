defmodule Simon.Sale.Quotation do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Simon.Sale.Quotation

  schema "quotations" do
    field :status, Ecto.Enum, values: [:draft, :sent, :accepted, :rejected], default: :draft
    field :total, :decimal
    field :currency, :string
    field :valid_until, :date
    field :notes, :string

    belongs_to :customer, Simon.Relationship.Account
    many_to_many :products, Simon.Sale.Product, join_through: "quotations_products"

    timestamps()
  end
end
