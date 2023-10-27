defmodule Simon.Catalog.Category.Finders.ListAllCategories do
  alias Simon.Catalog.Category.Repo
  alias Simon.Catalog.Product.Finders.CountProductByCategory

  def run do
    Repo.all()
    |> Enum.map(fn category ->
      category
      |> Map.put(:product_count, CountProductByCategory.run(category.id))
    end)
    |> IO.inspect()
  end
end
