# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Simon.Repo.insert!(%Simon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Simon.HumanResources.Member
alias Simon.HumanResources
alias Simon.Repo

Repo.delete_all(Member)

if Mix.env() == :dev do
  IO.puts("Seeding development database")

  HumanResources.register_member(%{
    phone_number: "1234567890",
    password: "simontest1234"
  })
end
