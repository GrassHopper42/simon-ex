defmodule Simon.Repo.Migrations.AddSearchColumnToProduct do
  use Ecto.Migration

  def change do
    execute """
      ALTER TABLE products
      ADD COLUMN search tsvector;
      """

      execute """
      CREATE INDEX products_search_idx ON products USING gin(search)
      """
  end
end
