defmodule ExWallet.RippleAddress do
  @moduledoc """
  Generates a Ripple network's compatible address account. Ripple address
  starts with `r`.
  """
  alias ExWallet.{Compression, KeyPair}

  defguardp is_pub_key_size(key) when byte_size(key) == 65
  defguardp is_compressed_pub_key_size(key) when byte_size(key) == 33

  @doc """
  Generates an address from given public key. The public key can be compressed
  with 33 bytes or their original size with 65.
  """
  def from_public_key(pub_key) when is_compressed_pub_key_size(pub_key),
    do: calculate(pub_key)

  def from_public_key(pub_key) when is_pub_key_size(pub_key),
    do: pub_key |> Compression.run() |> calculate()

  @doc """
  Generates an address from given private key.
  """
  def from_private_key(private_key) do
    private_key
    |> KeyPair.to_public_key()
    |> Compression.run()
    |> calculate()
  end

  defp calculate(pub_key_bytes) do
    pub_key_bytes
    |> sha256()
    |> ripemd160()
    |> B58.encode58_check!(0, alphabet: :ripple)
  end

  defp sha256(data), do: :crypto.hash(:sha256, data)

  defp ripemd160(data), do: :crypto.hash(:ripemd160, data)
end
