defmodule Simon.Relationship.Contact do
  @moduledoc false

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          phone: String.t(),
          email: String.t(),
          title: String.t(),
          is_owner: boolean(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :phone, :string
    field :email, :string
    field :title, :string
    field :is_owner, :boolean, default: false

    many_to_many :parties, Simon.Relationship.Party, join_through: "contacts_parties"

    timestamps()
  end

  @permitted_fields [:name, :title, :phone, :email]
  @required_fields [:name, :phone]

  def register_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(%__MODULE__{} = contact, attrs) do
    contact
    |> cast(attrs, @permitted_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:parties)
  end
end
