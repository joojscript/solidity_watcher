defmodule Solidity.Watcher do
  @otp_app Application.get_application(__MODULE__)
  @solidity_repo_url "https://github.com/ethereum/solidity"

  require Logger

  def install_and_run(profile, args) when is_atom(profile) and is_list(args) do
    executable_path = System.find_executable("solc")

    if is_nil(executable_path) do
      install()
    end

    :fs.start_link(@otp_app, Application.get_env(@otp_app, :contracts_path, "contracts"))
    :fs.subscribe(@otp_app)

    run()
    wait_for_reload()
  end

  def wait_for_reload do
    receive do
      {_watcher_process, {:fs, :file_event}, {changedFile, _type}} ->
        IO.puts("#{changedFile} was updated. Recompiling...")
        run()
        wait_for_reload()
    end
  end

  def run do
    build_command =
      "#{bin_path()} --abi --bin --overwrite -o #{output_path()} #{contracts_path()}"

    build_command
    |> System.shell()
    |> elem(0)
    |> String.trim()
    |> Logger.info()
  end

  def install do
    version = solidity_version()
    distro = :os.type() |> elem(1) |> formatted_distro_name

    {version, distro}
    |> build_download_url
    |> download_release
  end

  defp solidity_version do
    Application.get_env(@otp_app, :version, "latest")
  end

  defp download_release({_, _, download_url}) do
    binary = fetch_body!(download_url)
    File.mkdir_p!(Path.dirname(bin_path()))
    File.write!(bin_path(), binary, [:binary])
    File.chmod(bin_path(), 0o755)
  end

  defp fetch_body!(url) do
    url = String.to_charlist(url)
    Logger.debug("Downloading Solidity Compiler from #{url}")

    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    if proxy = System.get_env("HTTP_PROXY") || System.get_env("http_proxy") do
      Logger.debug("Using HTTP_PROXY: #{proxy}")
      %{host: host, port: port} = URI.parse(proxy)
      :httpc.set_options([{:proxy, {{String.to_charlist(host), port}, []}}])
    end

    if proxy = System.get_env("HTTPS_PROXY") || System.get_env("https_proxy") do
      Logger.debug("Using HTTPS_PROXY: #{proxy}")
      %{host: host, port: port} = URI.parse(proxy)
      :httpc.set_options([{:https_proxy, {{String.to_charlist(host), port}, []}}])
    end

    # https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/inets
    cacertfile = CAStore.file_path() |> String.to_charlist()

    http_options = [
      ssl: [
        verify: :verify_peer,
        cacertfile: cacertfile,
        depth: 2,
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      ]
    ]

    options = [body_format: :binary]

    case :httpc.request(:get, {url, []}, http_options, options) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        body

      other ->
        raise "couldn't fetch #{url}: #{inspect(other)}"
    end
  end

  defp build_download_url({version, distro}) do
    {version, distro, "#{@solidity_repo_url}/releases/#{version}/download/solc-#{distro}"}
  end

  defp formatted_distro_name(distro) do
    case distro do
      :darwin -> "macos"
      :windows -> "windows.exe"
      :linux -> "static-linux"
      _ -> "static-linux"
    end
  end

  defp bin_path, do: bin_path(solidity_version())

  defp bin_path(version) do
    name = "solidity-#{version}"

    Application.get_env(@otp_app, :solc_path) ||
      if Code.ensure_loaded?(Mix.Project) do
        Path.join(Path.dirname(Mix.Project.build_path()), name)
      else
        Path.expand("_build/#{name}")
      end
  end

  defp contracts_path do
    Application.get_env(@otp_app, :contracts_path, "contracts/*.sol")
  end

  defp output_path do
    Application.get_env(@otp_app, :output_path, "solidity_build")
  end
end
