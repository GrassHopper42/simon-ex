defmodule Simon.Catalog.Product.Finders.ListAllProducts do
  alias Simon.Repo

  def run do
    Simon.Catalog.Product.Repo.all()
    |> Repo.preload(:category)
  end
end
