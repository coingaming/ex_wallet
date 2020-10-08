defmodule ExWallet.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_wallet,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:libsecp256k1, "~> 0.1.10"},
      # Check: https://github.com/nocursor/b58/pull/1
      {:basefiftyeight, "~> 0.1.0", github: "ulissesalmeida/b58", branch: "remove-prefix"},
      {:keccakf1600, "~> 2.0", hex: :keccakf1600_orig},
      {:stream_data, "~> 0.4", only: [:test]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
