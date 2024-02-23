defmodule Simon.Repo.Migrations.CreateParties do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:parties) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :tax_id, :string, null: true
      add :address, :string, null: true
      add :memo, :text, null: true

      timestamps()
    end
  end
end
