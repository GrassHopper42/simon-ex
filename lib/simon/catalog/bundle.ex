defmodule Simon.Catalog.Bundle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bundles" do
    field :name, :string

    many_to_many :products, Simon.Catalog.Product, join_through: Simon.Catalog.ProductBundle

    timestamps()
  end

  @doc false
  def changeset(bundle, attrs) do
    bundle
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:products, required: true)
  end
end
