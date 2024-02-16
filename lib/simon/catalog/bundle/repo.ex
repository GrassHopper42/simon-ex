defmodule Simon.Catalog.Bundle.Repo do
  alias Simon.Catalog.Bundle
  alias Simon.Repo

  def all(query \\ Bundle) do
    Repo.all(query)
  end
end
