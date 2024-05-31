defmodule Simon.Sale.Quotation do
  @moduledoc false
  alias Simon.Sale.Quote.QuotationLine

  use Ecto.Schema
  import Ecto.Changeset

  schema "quotations" do
    field :quotation_number, :string
    field :total_amount, :integer
    field :total_quantity, :integer
    field :memo, :string
    field :reference, :string
    field :status, Ecto.Enum, values: [:draft, :confirmed, :cancelled], default: :draft

    belongs_to :order, Simon.Sale.Order, foreign_key: :order_id
    belongs_to :customer, Simon.Relationship.Party, foreign_key: :customer_id
    belongs_to :pic, Simon.HumanResources.Member, foreign_key: :pic_id
    has_many :quotation_lines, QuotationLine, on_delete: :delete_all

    timestamps()
  end

  def registration_changeset(%__MODULE__{} = quotation, attrs \\ %{}) do
    quotation
    |> changeset(attrs)
    |> put_quotation_number()
  end

  def changeset(%__MODULE__{} = quotation, attrs \\ %{}) do
    quotation
    |> cast(attrs, [:customer_id, :pic_id])
    |> cast_assoc(:quotation_lines)
    |> cast_assoc(:customer)
    |> cast_assoc(:pic)
    |> calculate_total_amount()
    |> calculate_total_quantity()
  end

  defp generate_quotation_number do
    Integer.to_string(:os.system_time(:millisecond)) <> Integer.to_string(:rand.uniform(9_000))
  end

  defp put_quotation_number(changeset) do
    changeset
    |> put_change(:quotation_number, generate_quotation_number())
  end

  defp calculate_total_amount(changeset) do
    total_amount =
      changeset
      |> get_assoc(:quotation_lines, :struct)
      |> Enum.reduce(0, fn line, acc -> acc + line.amount end)

    changeset
    |> put_change(:total_amount, total_amount)
  end

  defp calculate_total_quantity(changeset) do
    total_quantity =
      changeset
      |> get_assoc(:quotation_lines, :struct)
      |> Enum.reduce(0, fn line, acc -> acc + line.quantity end)

    changeset
    |> put_change(:total_quantity, total_quantity)
  end
end
