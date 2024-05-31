defmodule Simon.Sale.Quote.QuotationLine do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "quotation_lines" do
    field :product_name, :string
    field :quantity, :integer
    field :unit_price, :integer
    field :amount, :integer
    field :memo, :string

    belongs_to :quotation, Simon.Sale.Quotation
    belongs_to :product, Simon.Catalog.Product

    timestamps()
  end

  def changeset(%__MODULE__{} = quotation_line, attrs \\ %{}) do
    quotation_line
    |> cast(attrs, [:line_number, :quantity, :unit_price, :amount, :quotation_id, :product_id])
    |> validate_required([
      :line_number,
      :quantity,
      :unit_price,
      :amount,
      :quotation_id,
      :product_id
    ])
  end
end
