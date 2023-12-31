defmodule Simon.HumanResources.Service.RegisterNewMember do
  import Simon.HumanResources.Repo

  def call(attrs) do
    with {:ok, member} <- create(attrs) do
      {:ok, member}
    else
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
