defmodule Simon.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simon.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name",
        description: "some description",
        standard: "some standard",
        price: 42
      })
      |> Simon.Catalog.create_product()

    product
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Simon.Catalog.create_category()

    category
  end
end
