defmodule Simon.Catalog.Category.Service.DeleteCategory do
  alias Simon.Catalog.Category.Repo

  def run(id) do
    with {:ok, category} <- Repo.get(id),
         {:ok, _} <- Repo.delete(category),
         do: {:ok, category}
  end
end
