defmodule Simon.Repo.Migrations.CreateCategories do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :parent_category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:categories, [:parent_category_id])
  end
end
