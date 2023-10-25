defmodule Simon.Catalog.Product.Service.UpdateProductDetail do
  alias Simon.Catalog.Product.Repo

  def run(product, attrs) do
    with {:ok, product} <- Repo.update(product, attrs) do
      {:ok, product}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
