defmodule SolidityWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :solidity_watcher,
      version: "0.1.0",
      elixir: "~> 1.13.3",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :public_key, :fs]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:fs, "~> 2.12.0"},
      {:castore, ">= 0.0.0"}
    ]
  end
end
