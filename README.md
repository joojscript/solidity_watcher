# Solidity Watcher

A **very** tiny watcher for **Solidity Compiler** which runs in it own proccess, with ease to use.

### How the watcher works?

It looks into your environment, and try to find any `solc` (the Solidity compiler) and tries to run it, otherwise, it will just install a local copy of the `solc` latest release (or any version you want to specify).

## Installation

The package is [available in Hex](https://hex.pm/docs/publish), and can be installed
by adding `solidity_watcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:solidity_watcher, "~> 0.1.0"}
  ]
end
```

## Available Configuration

You can add all of these keys to `config/config.exs`, and the watcher will be set:

```elixir
# General application configuration
import Config

# Configures the endpoint
config :solidity_watcher,
  contracts_path: "contracts/*.sol", 
  output_path: "solidity_build",
  version: "8.0.2",
  solc_path: "/usr/share/applications/solc" # If already set on PATH, just ignore it.
```

- **contracts_path:** The path in which the compiler will look for Solidity contracts. Do not forget to add the wildcard (*.sol), or any specific file (test.sol);
- **output_path**: The path in which the compiler will output the compiled files from Solidity Compiler.
- **version:** In case the *solc_path* variable isn't set, or can't be found, the watcher will look for the releases from Solidity's Github repo. By default, the latest version, but you can always specify an specific one.
- **solc_path**: This variable, if set, explicit the path to the solc compiler. If you have it already installed, but not under PATH (if it is already in your path, than the watcher can find it).

---

The expected behavior is something like this:

```bash
==> solidity_watcher
Compiling 1 file (.ex)
[info] Running CypherWeb.Endpoint with cowboy 2.9.0 at 127.0.0.1:4000 (http)
[info] Access CypherWeb.Endpoint at http://localhost:4000
[info] Compiler run successful. Artifact(s) can be found in directory "solidity_build".
[watch] build finished, watching for changes...

Rebuilding...
Done in 206ms.
<PROJECT-PATH>/contracts/test.sol was updated. Recompiling...
[info] Compiler run successful. Artifact(s) can be found in directory "solidity_build".
<PROJECT-PATH>/contracts/test.sol was updated. Recompiling...
[info] Compiler run successful. Artifact(s) can be found in directory "solidity_build".
```

---

⚠️ **Warning**: A known error that might occur, is the following:

```elixir
[error] backend port not found: :inotifywait
```

In this case, the probability is that you don't have `inotify-tools` installed, which is a requirement for linux users, se more about that [here](https://github.com/synrc/fs).