defmodule Simon.Repo.Migrations.ProductDetailToEmbed do
  @moduledoc false

  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :description
      remove :standard
      add :detail, :map
    end
  end
end
