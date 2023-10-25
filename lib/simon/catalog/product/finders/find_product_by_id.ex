defmodule Simon.Catalog.Product.Finders.FindProductById do
  alias Simon.Catalog.Product.Repo

  def run(id) do
    Repo.get(id)
  end

  def run!(id) do
    Repo.get!(id)
  end
end
