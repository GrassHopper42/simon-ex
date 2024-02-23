defmodule Simon.HumanResources.Service.RegisterNewMember do
  @moduledoc false

  import Simon.HumanResources.Repo

  def call(attrs) do
    case create(attrs) do
      {:ok, member} -> {:ok, member}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
