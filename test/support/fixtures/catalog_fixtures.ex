defmodule Simon.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simon.Catalog` context.
  """

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

  @doc """
  Generate a unique product code.
  """
  def unique_product_code, do: "some code#{System.unique_integer([:positive])}"

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        code: unique_product_code(),
        name: "some name",
        description: "some description",
        standard: "some standard",
        price: 42
      })
      |> Simon.Catalog.create_product()

    product
  end
end
