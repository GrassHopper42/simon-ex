defmodule Simon.Catalog.Category.Service.RegisterRootCategory do
  @moduledoc """
  Register a new category in the catalog
  """

  alias Simon.Catalog.Category

  @doc """
  Register a new category in the catalog
  """
  @spec call(map) :: {:ok, Category.t()} | {:error, map}
  def call(attrs) do
    case Category.Repo.create(attrs) do
      {:ok, category} -> {:ok, category}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
