defmodule SolidityWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :solidity_watcher,
      version: "0.0.1",
      elixir: ">= 1.13.3",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Solidity Watcher",
      source_url: "https://github.com/joojscript/solidity_watcher",
      description: description(),
      package: package()
    ]
  end

  defp description do
    "Solidity Watcher is a tiny tool to watch for changes in your Solidity contracts and compile them."
  end

  defp package() do
    [
      name: "solidity_watcher",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joojscript/solidity_watcher"}
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
      {:castore, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
