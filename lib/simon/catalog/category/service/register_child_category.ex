defmodule Simon.Catalog.Category.Service.RegisterChildCategory do
  @moduledoc """
  Register a new category in the catalog
  """

  alias Simon.Catalog.Category
  import Simon.Catalog.Category.Repo

  @doc """
  Register a new category in the catalog
  """
  @spec call(map, integer()) :: {:ok, Category.t()} | {:error, map}
  def call(attrs, parent_category_id) do
    with {:ok, category} <- create(attrs, parent_category_id) do
      {:ok, category}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
