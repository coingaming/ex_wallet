defmodule ExWallet.Wif do
  alias ExWallet.Extended.Private

  @prefixes %{
    main: <<0x80>>,
    test: <<0xEF>>
  }

  def priv_to_wif(key, network \\ :main)
  def priv_to_wif(%Private{key: key}, network), do: priv_to_wif(key, network)

  def priv_to_wif(key, network) when is_binary(key) do
    version = Map.get(@prefixes, network)
    B58.encode58_check!(key, version)
  end
end
