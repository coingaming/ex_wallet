defmodule ExWallet.TronAddress do
  alias ExWallet.{Base58, KeyPair}

  # NOTE: Source:
  # https://github.com/tronprotocol/java-tron/blob/b6971699752adc455cf9a0b53c09c1ab042eaaf8/src/test/java/stest/tron/wallet/common/client/Parameter.java#L12
  @version_bytes %{
    main: <<0x41>>,
    test: <<0xa0>>
  }

  # NOTE: Algorithm: https://developers.tron.network/docs/account
  def calculate(private_key, network \\ :main) do
    private_key
    |> KeyPair.to_public_key()
    |> pub_key_64_bytes()
    |> Silicon.Hash.keccak_256()
    |> get_last_20_bytes()
    |> prepend_version_byte(network)
    |> Base58.check_encode()
  end

  defp prepend_version_byte(public_hash, network) do
    @version_bytes
    |> Map.get(network)
    |> Kernel.<>(public_hash)
  end

  defp get_last_20_bytes(data), do: :binary.part(data, byte_size(data), -20)

  # NOTE: Source:
  # Public key should be 64 bytes: https://developers.tron.network/docs/account
  # Example in code:
  # https://github.com/tronprotocol/tron-demo/blob/cccff07a401bf1d7fa12e28c8f2be8ce5fba9d15/demo/nodejs/src/utils/crypto.js#L79
  defp pub_key_64_bytes(<<_::binary-size(1), response::binary-size(64)>>), do: response
  defp pub_key_64_bytes(data) when byte_size(data) == 64, do: data
end
