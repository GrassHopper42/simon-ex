defmodule Simon.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :code, :string
    field :name, :string
    field :description, :string
    field :standard, :string
    field :price, :integer
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:code, :name, :standard, :description, :price])
    |> validate_required([:code, :name, :standard, :description, :price])
    |> unique_constraint(:code)
  end
end
