defmodule Solidity.WatcherTest do
  use ExUnit.Case
  doctest Solidity.Watcher
  @otp_app :solidity_watcher
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
