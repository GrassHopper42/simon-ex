defmodule Simon.Catalog.Product.Value.Price do
  @moduledoc false

  alias Simon.Catalog.Product.Value.Price
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :cost, :integer, default: 0
    field :price, :integer, default: 0
  end

  def changeset(%Price{} = price, attrs \\ %{}) do
    price
    |> cast(attrs, [:cost, :price])
  end
end
