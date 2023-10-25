defmodule Simon.Catalog.Product.Service.DeleteProduct do
  alias Simon.Catalog.Product.Repo

  def run(id) do
    with {:ok, product} <- Repo.get(id),
         {:ok, _} <- Repo.delete(product),
         do: {:ok, product}
  end
end
