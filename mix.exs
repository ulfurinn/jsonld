defmodule UlfNet.JSONLD.MixProject do
  use Mix.Project

  def project do
    [
      app: :ulfnet_jsonld,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UlfNet.JSONLD.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json_ld, "~> 0.3"}
    ]
  end
end
