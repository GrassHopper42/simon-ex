defmodule Simon.Sale.Quote.Service.CreateNewQuotation do
  @moduledoc false

  alias Simon.Sale.Quotation
  alias Simon.Sale.Quote.QuotationLine
  alias Simon.Sale.Quote.Repo

  def create_new_quotation(attrs) do
    Quotation.changeset(%Quotation{}, attrs)
    |> Ecto.Changeset.put_assoc(:quotation_lines, build_quotation_lines(attrs))
    |> Repo.insert()
  end

  defp build_quotation_lines(attrs) do
    Enum.map(attrs.quotation_lines, &QuotationLine.changeset(%QuotationLine{}, &1))
  end
end
