defmodule ExWallet.Address do
  alias ExWallet.{KeyPair, Crypto}

  @version_bytes %{
    main: <<0x00>>,
    test: <<0x6F>>
  }

  def calculate(private_key, network \\ :main) do
    version = Map.get(@version_bytes, network)

    private_key
    |> KeyPair.to_public_key()
    |> Crypto.hash_160()
    |> B58.encode58_check!(version)
  end
end
