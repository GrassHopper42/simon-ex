defmodule Simon.Relationship.Service.RegisterNewParty do
  @moduledoc false

  alias Simon.Relationship.Repo
  alias Simon.Relationship.Party

  def call(attrs) do
    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end
end
