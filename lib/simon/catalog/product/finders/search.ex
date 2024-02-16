defmodule Simon.Catalog.Product.Finders.Search do
  @moduledoc false

  def run(query) do
    Simon.Meilisearch.search("products", query)
  end
end
