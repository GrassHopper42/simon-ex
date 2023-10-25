defmodule Simon.Catalog.Product.Repo do
  @moduledoc """
  Product Repo
  """
  alias Simon.Repo
  alias Simon.Catalog.Product

  def create(attrs) do
    %Product{}
    |> Product.registration_changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Product.t(), map) :: {:ok, Product.t()} | {:error, map}
  def update(product, attrs) do
    product
    |> Product.update_changeset(attrs)
    |> Repo.update()
  end

  def all do
    Repo.all(Product)
  end

  @doc """
  Find Product by id
  """
  @spec get(Integer) :: {:ok, Product.t()} | {:error, map}
  def get(id) do
    product = Repo.get(Product, id)

    case product do
      nil -> {:error, %{id: ["Product not found"]}}
      _ -> {:ok, product}
    end
  end

  def get!(id) do
    Repo.get!(Product, id)
  end

  @doc """
  Find Product by code
  """
  @spec get_by_code(String.t()) :: {:ok, Product.t()} | {:error, map}
  def get_by_code(code) do
    with {:ok, product} <- Repo.get_by(Product, code: code) do
      {:ok, product}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  def delete(product) do
    Repo.delete(product)
  end
end
