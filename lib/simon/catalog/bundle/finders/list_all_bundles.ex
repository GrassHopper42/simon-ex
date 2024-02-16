defmodule Simon.Catalog.Bundle.Finders.ListAllBundles do
  alias Simon.Catalog.Bundle
  alias Simon.Catalog.Bundle.Repo

  @doc """
  List all bundles
  """
  @spec call() :: [Bundle.t()]
  def call() do
    Repo.all(Bundle)
  end
end
