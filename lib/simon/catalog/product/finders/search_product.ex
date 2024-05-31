defmodule Simon.Catalog.Product.Finders.SearchProduct do
  @moduledoc false
  alias Simon.Catalog.Product

  def run(query) do
    Simon.Meilisearch.search("products", query)
    |> Enum.map(fn result ->
      %Product{
        id: result["id"],
        code: result["code"],
        name: result["name"],
        price: result["price"],
        detail: result["detail"],
        category_id: result["category_id"]
      }
    end)
  end
end
