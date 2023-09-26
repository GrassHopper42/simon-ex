defmodule Simon.Repo do
  use Ecto.Repo,
    otp_app: :simon,
    adapter: Ecto.Adapters.Postgres
end
