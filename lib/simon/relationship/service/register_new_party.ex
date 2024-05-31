defmodule Simon.Relationship.Service.RegisterNewParty do
  @moduledoc false

  alias Simon.Relationship.Repo

  def call(attrs) do
    attrs
    |> Repo.create_party()
  end
end
