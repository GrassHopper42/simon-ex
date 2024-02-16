defmodule Simon.Catalog.Product.Finders.CountProductByCategory do
  @moduledoc false

  import Ecto.Query

  alias Simon.Repo

  def run(category_id) do
    Repo.one(
      from p in Simon.Catalog.Product,
        where: p.category_id == ^category_id,
        select: count(p.id)
    )
  end
end
