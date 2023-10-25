defmodule Simon.Catalog.Category.Service.UpdateCategoryName do
  alias Simon.Catalog.Category
  alias Simon.Catalog.Category.Repo

  def call(%Category{} = category, %{name: _} = attrs) do
    with {:ok, category} <- Repo.update(category, attrs) do
      {:ok, category}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
