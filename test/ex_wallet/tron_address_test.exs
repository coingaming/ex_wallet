defmodule ExWallet.TronAddressTest do
  use ExUnit.Case, async: true

  # NOTE: Source: https://github.com/rodyce/tron-tests/blob/master/tron-wallet-gen.js
  setup do
    master_key =
      "kit youth enroll gravity inform coil life response over collect shrimp fashion desk million differ style october hill first fiscal reform among fiscal word"
      |> ExWallet.Seed.generate()
      |> ExWallet.Extended.master()

    path = "m/44'/195'/0'/0"

    expected = %{
      0 => "TVSpgfe4aHESGaSG6aQzpML2cH9fG2ZEac",
      1 => "THYRxuoUz1WAjUX1R6BT3MY9bZWyLcJfpA",
      2 => "TKyttcDZ3hxpW92VHnPQ5choe4beCz3Xtz",
      3 => "TFQxqYWRLMrNeEMNyFGERmuVj6RqD5qRuu",
      4 => "TZ4ZuGQaERxWxXCPgejmRSm4QSSTUzYEkz",
      5 => "THqTsRUD5u4v3UkSLn3DHitE8g3PRcpoLe",
      6 => "TY6kVKJnB8WSz8iWSfN4yjJ9jkFfEa6J8k",
      7 => "TNd5AKMsF54GCsWuN4HfbsJpmaEDAQevr7",
      8 => "TBTH87zBoKGGYbAg7YHxjmapg3HNeF5oJn",
      9 => "TYZsqqC67K9ycx4hjPKVwcgc6jieuJgD5D"
    }

    %{master_key: master_key, expected: expected, path: path}
  end

  test "correct wallet generation", %{master_key: master_key, path: path, expected: expected} do
    Enum.map(0..9, fn n ->
      %{key: child} = ExWallet.Extended.Children.derive(master_key, path <> "/#{n}")
      assert expected[n] == ExWallet.TronAddress.calculate_base58(child)
    end)
  end
end
