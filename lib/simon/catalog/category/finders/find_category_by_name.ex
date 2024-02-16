defmodule Simon.Catalog.Category.Finders.FindCategoryByName do
  @moduledoc """
  Find Category by name
  """

  alias Simon.Catalog.Category.Repo
  alias Simon.Catalog.Category

  @doc """
  Run the finder
  """
  @spec run(String.t()) :: {:ok, Category.t()} | :error
  def run(name) do
    Repo.get_by_name(name)
  end
end
