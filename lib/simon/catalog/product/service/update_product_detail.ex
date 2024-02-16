defmodule Simon.Catalog.Product.Service.UpdateProductDetail do
  @moduledoc false

  alias Simon.Catalog.Product.Repo

  def run(product, attrs) do
    with {:ok, product} <- Repo.update(product, attrs) do
      Simon.Meilisearch.add_or_update("products", [product])
      {:ok, product}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
