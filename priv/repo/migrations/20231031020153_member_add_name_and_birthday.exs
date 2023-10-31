defmodule Simon.Repo.Migrations.MemberAddNameAndBirthday do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :name, :string
      add :birthday, :date
    end
  end
end
