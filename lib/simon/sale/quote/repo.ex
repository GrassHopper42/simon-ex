defmodule Simon.Sale.Quote.Repo do
  @moduledoc false

  alias Simon.Sale.Quotation
  alias Simon.Repo

  def all_quotations do
    Repo.all(Simon.Sale.Quotation)
  end

  def get_quotation!(id) do
    Repo.get!(Simon.Sale.Quotation, id)
  end

  def get_quotation(id) do
    Repo.get(Simon.Sale.Quotation, id)
  end

  def create_quotation(%Quotation{} = qutoation) do
    Repo.insert(qutoation)
  end
end
