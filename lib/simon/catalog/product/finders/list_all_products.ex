defmodule Simon.Catalog.Product.Finders.ListAllProducts do
  def run do
    Simon.Catalog.Product.Repo.all()
  end
end
