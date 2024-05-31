defmodule Simon.Relationship.Finders.SearchParty do
  @moduledoc false
  alias Simon.Relationship.Repo

  def run(query) do
    Repo.find_party_by_name(query)
  end
end
