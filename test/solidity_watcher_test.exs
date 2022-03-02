defmodule SolidityWatcherTest do
  use ExUnit.Case
  doctest SolidityWatcher
  @otp_app Application.get_application(__MODULE__)

  test "installs the solc compiler" do
    version = Application.get_env(@otp_app, :version, "latest")

    Solidity.Watcher.install()

    assert "#{Mix.Project.build_path()}/solidity-#{version}"

    unless version == "latest" do
      assert System.shell("#{Mix.Project.build_path()}/solidity-#{version}/solc --version")
             |> elem(0)
             |> Kernel.=~(version)
    end
  end
end
