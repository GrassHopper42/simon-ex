defmodule Simon.Relationship.Repo do
  @moduledoc false

  import Ecto.Query

  alias Simon.Repo
  alias Simon.Relationship.Party
  alias Simon.Relationship.Contact

  def create_party(attrs) do
    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  def all_parties do
    Party
    |> Repo.all()
  end

  def find_party_by_id(id) do
    Repo.get(Party, id)
  end

  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end

  def create_contact(attrs) do
    Contact.register_changeset(attrs)
    |> Repo.insert()
  end

  def all_contacts do
    Contact
    |> Repo.all()
  end

  def find_contacts_by_phone(phone) do
    query =
      from c in Contact,
        where: like(c.phone, ^"%#{phone}%"),
        select: c

    Repo.all(query)
  end

  def search_contacts(query) do
    query =
      from c in Contact,
        where:
          like(c.name, ^"%#{query}%") or like(c.phone, ^"%#{query}%") or
            like(c.email, ^"%#{query}%"),
        select: c

    Repo.all(query)
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def find_party_by_contact(%Contact{} = contact) do
    contact
    |> Repo.preload(:parties)
  end
end
