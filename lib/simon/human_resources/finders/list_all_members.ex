defmodule Simon.HumanResources.Finders.ListAllMembers do
  @moduledoc false

  alias Simon.HumanResources.Repo

  def run() do
    Repo.all()
  end
end
