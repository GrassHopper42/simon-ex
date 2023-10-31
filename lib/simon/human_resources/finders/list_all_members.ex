defmodule Simon.HumanResources.Finders.ListAllMembers do
  alias Simon.HumanResources.Repo

  def run() do
    Repo.all()
  end
end
