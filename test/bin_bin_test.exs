defmodule BinBinTest do
  use ExUnit.Case

  test "should split items correctly" do
    input = ~s(123:123)
    expected = {~s(123), ~s(:123)}

    result = BinBin.split_while(input, fn c -> c in ?0..?9 end)

    assert expected == result
  end
end
