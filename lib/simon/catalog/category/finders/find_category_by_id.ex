defmodule Simon.Catalog.Category.Finders.FindCategoryById do
  @moduledoc """
    Find category by id
  """

  alias Simon.Catalog.Category.Repo
  alias Simon.Catalog.Category

  @spec run(integer) :: {:ok, Category.t()} | :error
  def run(id) do
    Repo.get(id)
  end

  @spec run!(integer) :: Category.t()
  def run!(id) do
    Repo.get!(id)
  end
end
