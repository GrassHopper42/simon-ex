defmodule Simon.Catalog.Product.Finders.Search do
  import Ecto.Query
  alias Simon.Repo

  def run(query) do
    query
    |> build_query
    |> Repo.all()
  end

  defp build_query(query) do
    query
    |> filter_by_category()
    |> filter_by_code()
    |> filter_by_name()
    |> filter_by_detail()
  end

  defp filter_by_code(query) do
    case query.code do
      nil -> query
      code -> where(query, [p], p.code == ^code)
    end
  end

  defp filter_by_name(query) do
    case query.name do
      nil -> query
      name -> where(query, [p], p.name == ^name)
    end
  end

  defp filter_by_category(query) do
    case query.category do
      nil -> query
      category -> where(query, [p], p.category_id == ^category)
    end
  end

  defp filter_by_description(query) do
    case query.description do
      nil -> query
      description -> where(query, [p], p.description == ^description)
    end
  end

  defp filter_by_standard(query) do
    case query.standard do
      nil -> query
      standard -> where(query, [p], p.standard == ^standard)
    end
  end

  defp filter_by_detail(query) do
    query
    |> filter_by_description()
    |> filter_by_standard()
  end
end
