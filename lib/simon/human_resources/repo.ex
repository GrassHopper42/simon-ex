defmodule Simon.HumanResources.Repo do
  import Ecto.Query

  alias Simon.Repo
  alias Simon.HumanResources.Member

  def create(attrs) do
    %Member{}
    |> Member.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get!(id), do: Repo.get!(Member, id)

  def all do
    query =
      from Member,
        select: [:id, :name, :birthday, :phone_number]

    Repo.all(query)
  end

  def find_by_phone_number(phone_number) do
    query =
      from Member,
        where: like(:phone_number, ^"%#{phone_number}%"),
        select: [:id, :name, :birthday, :phone_number]

    Repo.all(query)
  end
end
