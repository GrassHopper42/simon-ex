defmodule Simon.Catalog.Category.Repo do
  @moduledoc """
    Category Repo
  """

  alias Simon.Catalog.Category
  alias Simon.Repo

  def all(query \\ Category) do
    Repo.all(query)
  end

  @spec get(integer) :: {:ok, Category.t()} | :error
  def get(id) do
    Repo.get(Category, id)
  end

  @spec get!(integer) :: Category.t()
  def get!(id) do
    Repo.get!(Category, id)
  end

  @spec get_by_name(String.t()) :: {:ok, Category.t()} | :error
  def get_by_name(name) do
    Repo.get_by(Category, name: name)
  end

  @spec create(map, integer) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, parent_category_id) do
    get(parent_category_id)
    |> Ecto.build_assoc(:child_categories)
    |> create(attrs)
  end

  @spec create(map) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Category.t(), map) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def update(category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a category
  """
  @spec delete(Category.t()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def delete(category) do
    category
    |> Repo.delete()
  end
end
