defmodule SolidityWatcherTest do
  use ExUnit.Case
  doctest SolidityWatcher
  @otp_app Application.get_application(__MODULE__)
  import Config

  test "installs the solc compiler" do
    version = Application.get_env(@otp_app, :version, "latest")

    Solidity.Watcher.install()

    assert File.exists?("#{Mix.Project.build_path()}/../solidity-#{version}")

    unless version == "latest" do
      assert System.shell("#{Mix.Project.build_path()}/../solidity-#{version} --version")
             |> elem(0)
             |> Kernel.=~(version)
    end
  end
end
