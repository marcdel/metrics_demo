defmodule MetricsDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    OpenTelemetry.register_application_tracer(:metrics_demo)

    children = [
      # Start the Ecto repository
      MetricsDemo.Repo,
      # Start the Telemetry supervisor
      MetricsDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MetricsDemo.PubSub},
      # Start the Endpoint (http/https)
      MetricsDemoWeb.Endpoint,
      # Start a worker by calling: MetricsDemo.Worker.start_link(arg)
      # {MetricsDemo.Worker, arg}
      MetricsDemo.MetricsGenerator
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MetricsDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MetricsDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
