defmodule Simon.Catalog.Category.Finders.ListAllCategories do
  alias Simon.Catalog.Category.Repo

  def run do
    Repo.all()
  end
end
