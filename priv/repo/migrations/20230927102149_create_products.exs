defmodule Simon.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :code, :string
      add :name, :string
      add :standard, :string
      add :description, :text
      add :price, :integer
      add :category_id, references(:cataegories, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:products, [:code])
    create index(:products, [:category_id])
  end
end
