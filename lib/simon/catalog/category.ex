defmodule Simon.Catalog.Category do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Simon.Catalog.Category

  schema "categories" do
    field :name, :string
    belongs_to :parent_category, Simon.Catalog.Category
    has_many :child_categories, Simon.Catalog.Category, foreign_key: :parent_category_id

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
