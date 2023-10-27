defmodule B5gAppObjectdetect.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    target_giocci_relay_name = System.get_env("TARGET_GIOCCI_RELAY_NAME") |> Code.eval_string |> elem(0)
    children = [
      # Start the Telemetry supervisor
      B5gAppObjectdetectWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: B5gAppObjectdetect.PubSub},
      # Start the Endpoint (http/https)
      B5gAppObjectdetectWeb.Endpoint,
      {Giocci, [target_giocci_relay_name]}
      # Start a worker by calling: B5gAppObjectdetect.Worker.start_link(arg)
      # {B5gAppObjectdetect.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: B5gAppObjectdetect.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    B5gAppObjectdetectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
