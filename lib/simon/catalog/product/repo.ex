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

  def all(query \\ Product) do
    Repo.all(query)
  end

  @doc """
  Find Product by id
  """
  @spec get(integer()) :: {:ok, Product.t()} | {:error, atom()}
  def get(id) do
    case Repo.get(Product, id) do
      nil -> {:error, :not_found}
      product -> {:ok, product}
    end
  end

  @spec get!(integer()) :: Product.t()
  def get!(id) do
    Repo.get!(Product, id)
  end

  @doc """
  Find Product by code
  """
  @spec get_by_code(String.t()) :: {:ok, Product.t()} | {:error, map}
  def get_by_code(code) do
    case Repo.get_by(Product, code: code) do
      {:ok, product} -> {:ok, product}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  @spec delete(Product.t()) :: {:ok, Product.t()} | {:error, any()}
  def delete(product) do
    Repo.delete(product)
  end
end
