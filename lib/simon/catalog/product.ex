defmodule Simon.Catalog.Product do
  @moduledoc false

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
    |> cast(attrs, [:category_id, :code, :name, :price])
    |> validate_required([:category_id, :code, :name, :price], message: "필수 입력 사항입니다.")
    |> validate_code()
    |> validate_name()
    |> validate_number(:price, greater_than_or_equal_to: 0, message: "가격은 0 이상이어야 합니다.")
    |> cast_category()
    |> put_embed(:detail, %ProductDetail{})
  end

  @doc false
  def update_changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:category_id, :code, :name, :price])
    |> validate_required([:category_id, :code, :name, :price])
    |> validate_code()
    |> validate_name()
    |> validate_number(:price, greater_than_or_equal_to: 0, message: "가격은 0 이상이어야 합니다.")
    |> cast_category()
    |> cast_embed(:detail)
  end

  def changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:category_id, :code, :name, :price])
    |> unique_constraint(:code)
    |> cast_embed(:detail)
  end

  def registration_change(product, attrs) do
    Product.registration_changeset(product, attrs)
  end

  defp validate_code(changeset) do
    changeset
    |> unique_constraint(:code, message: "이미 등록된 코드입니다.")
    |> validate_length(:code, min: 8, message: "코드는 8자 이상이어야 합니다.")
  end

  defp validate_name(changeset) do
    changeset
    |> validate_length(:name, min: 1, message: "이름은 1자 이상이어야 합니다.")
  end

  defp cast_category(changeset) do
    changeset
    |> cast_assoc(:category, required: true, message: "카테고리를 선택하세요.")
  end
end
