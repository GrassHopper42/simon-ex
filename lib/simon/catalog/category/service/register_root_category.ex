defmodule Simon.Catalog.Category.Service.RegisterRootCategory do
  @moduledoc """
  Register a new category in the catalog
  """

  alias Simon.Catalog.Category
  import Simon.Catalog.Category.Repo

  @doc """
  Register a new category in the catalog
  """
  @spec call(map) :: {:ok, Category.t()} | {:error, map}
  def call(attrs) do
    with {:ok, category} <- create(attrs) do
      {:ok, category}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
