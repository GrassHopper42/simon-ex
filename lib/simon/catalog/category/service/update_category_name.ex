defmodule Simon.Catalog.Category.Service.UpdateCategoryName do
  alias Simon.Catalog.Category

  def call(%Category{} = category, %{name: _} = attrs) do
    with {:ok, category} <- Category.Repo.update(category, attrs) do
      {:ok, category}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end
end
