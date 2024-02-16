defmodule Simon.Catalog.Product.Value.ProductDetail do
  @moduledoc false

  alias Simon.Catalog.Product.Value.ProductDetail
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :description, :string, default: ""
    field :standard, :string, default: ""
  end

  def changeset(%ProductDetail{} = detail, attrs \\ %{}) do
    detail
    |> cast(attrs, [:description, :standard])
  end
end
