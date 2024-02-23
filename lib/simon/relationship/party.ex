defmodule Simon.Relationship.Party do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @permitted_columns [:name, :type, :tax_id, :address, :memo]
  @required_columns [:name, :type]

  schema "parties" do
    field :name, :string
    field :type, Ecto.Enum, values: [:person, :organization], default: :organization
    field :tax_id, :string
    field :address, :string
    field :memo, :string

    many_to_many :contacts, Simon.Relationship.Contact, join_through: "contacts_parties"

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = party, attrs \\ %{}) do
    party
    |> cast(attrs, @permitted_columns)
    |> validate_required
  end

  defp validate_tax_id(changeset) do
    changeset
    |> validate_required([:tax_id])
    |> validate_length(:tax_id, min: 10, max: 10)
    |> validate_format(:tax_id, ~r/^\d{10}$/)
  end

  defp validate_required(changeset) do
    type = get_field(changeset, :type)

    case type do
      :organization ->
        changeset
        |> validate_required(@required_columns)
        |> validate_tax_id

      _ ->
        changeset
        |> validate_required(@required_columns)
    end
  end
end
