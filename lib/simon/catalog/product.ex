defmodule Simon.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Simon.Catalog.Category
  alias Simon.Catalog.Product
  alias Simon.Catalog.Product.Value.ProductDetail

  schema "products" do
    field :code, :string
    field :name, :string
    field :price, :integer

    embeds_one :detail, ProductDetail, on_replace: :update

    belongs_to :category, Category, foreign_key: :category_id

    timestamps()
  end

  def registration_changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:code, :name, :price])
    |> validate_required([:code, :name, :price])
    |> validate_length(:code, min: 8)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:code)
    |> put_embed(:detail, %ProductDetail{})
  end

  @doc false
  def update_changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:code, :name, :price])
    |> cast_embed(:detail)
    |> validate_required([:code, :name, :price])
    |> validate_length(:code, min: 8)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:code)
  end

  def changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:code, :name, :price])
    |> unique_constraint(:code)
    |> cast_embed(:detail)
  end

  def registration_change(product, attrs) do
    Product.registration_changeset(product, attrs)
  end
end
