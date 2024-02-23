defmodule Simon.Relationship.Finders.ListAllParties do
  @moduledoc false

  alias Simon.Relationship.Repo

  def run do
    Repo.all_parties()
  end
end
