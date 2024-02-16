defmodule Simon.Catalog.Category.Service.ImportCategories do
  @moduledoc false

  alias Simon.Catalog.Category

  @doc """
  Import categories from a CSV file
  """
  def call([]) do
    {:error, "No data to import"}
  end

  @spec call(list) :: {:ok, list(Category.t())} | {:error, binary}
  def call(rows) do
    import_categories(rows)
  end

  defp import_categories([]), do: {:ok, []}

  defp import_categories([row | rows]) do
    case Category.Service.RegisterRootCategory.call(row) do
      {:ok, category} ->
        import_categories(rows)
        |> case do
          {:ok, categories} -> {:ok, [category | categories]}
          {:error, _} -> {:error, "Failed to import categories"}
        end

      {:error, _} ->
        {:error, "Failed to import categories"}
    end
  end
end
