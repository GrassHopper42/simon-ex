defmodule Simon.Relationship.Finders.FindPartyById do
  @moduledoc false

  alias Simon.Relationship.Repo

  def run(id) do
    Repo.find_party_by_id(id)
  end
end
