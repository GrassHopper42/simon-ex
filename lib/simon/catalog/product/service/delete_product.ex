defmodule Simon.Catalog.Product.Service.DeleteProduct do
  @moduledoc false

  alias Simon.Catalog.Product.Repo

  @spec run(integer()) :: {:ok, Simon.Catalog.Product.t()} | {:error, any()}
  def run(id) do
    with {:ok, product} <- Repo.get(id),
         {:ok, _} <- Repo.delete(product) do
      Simon.Meilisearch.delete("products", [product.id])

      {:ok, product}
    else
      {:error, _} -> {:error, :not_found}
    end
  end
end
