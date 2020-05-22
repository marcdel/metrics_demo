defmodule MetricsDemo.Repo do
  use Ecto.Repo,
    otp_app: :metrics_demo,
    adapter: Ecto.Adapters.Postgres
end
