defmodule UlfNet.JSONLD.Application do
  use Application

  def start(_, _) do
    children = [
      UlfNet.JSONLD.Loader
    ]

    opts = [strategy: :one_for_one, name: UlfNet.JSONLD.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
