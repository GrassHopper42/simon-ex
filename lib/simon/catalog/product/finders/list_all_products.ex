defmodule Simon.Catalog.Product.Finders.ListAllProducts do
  @moduledoc false

  alias Simon.Repo

  def run do
    Simon.Catalog.Product.Repo.all()
    |> Repo.preload(:category)
  end
end
