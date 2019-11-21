defmodule ExWallet.RippleAddressTest do
  use ExUnit.Case, async: true

  use ExUnitProperties

  alias ExWallet.{KeyPair, RippleAddress, Extended}

  describe "from_public_key/1" do
    # https://xrpl.org/accounts.html#address-encoding
    test "generates a valid address using the docs pub key" do
      address =
        "ED9434799226374926EDA3B54B1B461B4ABF7237962EAE18528FEA67595397FA32"
        |> Base.decode16!()
        |> RippleAddress.from_public_key()

      assert "rDTXLQ7ZKZVKz33zJbHjgVShjsBnqMBhmN" == address
    end

    test "generates a valid address" do
      for _i <- 1..1000 do
        {pub_key, _priv} = KeyPair.generate()
        assert {payload, <<0>>} = pub_key |> RippleAddress.from_public_key() |> decode58_check()
      end
    end
  end

  describe "from_private_key/1" do
    test "generates a valid address" do
      for _i <- 1..1000 do
        {_pub, private_key} = KeyPair.generate()

        assert {payload, <<0>>} =
                 private_key |> RippleAddress.from_private_key() |> decode58_check()
      end
    end
  end

  property "generates valid adresses from HD Wallet" do
    check all seed <- positive_integer(),
              child <- positive_integer() do
      assert {payload, <<0>>} =
               seed
               |> Integer.to_string()
               |> Base.encode16()
               |> Extended.master()
               |> Extended.Children.derive("m/0'/1/2'/2/#{child}")
               |> Map.get(:key)
               |> RippleAddress.from_private_key()
               |> decode58_check()
    end
  end

  defp decode58_check(address), do: B58.decode58_check!(address, alphabet: :ripple)
end
