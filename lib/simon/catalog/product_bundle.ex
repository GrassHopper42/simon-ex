defmodule Simon.Catalog.ProductBundle do
  @moduledoc false

  use Ecto.Schema

  @primary_key false
  schema "products_bundles" do
    belongs_to :product, Simon.Catalog.Product
    belongs_to :bundle, Simon.Catalog.Bundle
    timestamps()
  end
end
