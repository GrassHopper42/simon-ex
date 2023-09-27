defmodule Simon.Repo.Migrations.CreateMembersAuthTables do
  @moduledoc false

  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:members) do
      add :phone_number, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:members, [:email])

    create table(:members_tokens) do
      add :member_id, references(:members, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:members_tokens, [:member_id])
    create unique_index(:members_tokens, [:context, :token])
  end
end
