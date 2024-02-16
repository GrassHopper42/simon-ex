defmodule Simon.Catalog.Bundle.Service.RegisterNewProduct do
  @moduledoc """
  Register a new product in the catalog
  """

  alias Simon.Catalog.Bundle
  import Simon.Catalog.Product.Repo

  @doc """
  Register a new product in the catalog
  """
  @spec call(map) :: {:ok, Product.t()} | {:error, map}
  def call(attrs) do
    with {:ok, product} <- create(attrs) do
      {:ok, product}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
