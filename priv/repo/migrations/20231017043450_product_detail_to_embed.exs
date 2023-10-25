defmodule Simon.Repo.Migrations.ProductDetailToEmbed do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :description
      remove :standard
      add :detail, :map
    end
  end
end
