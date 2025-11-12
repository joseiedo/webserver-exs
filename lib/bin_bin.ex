# Module for binary utils functions. The name is inspired by BlingBlingBoy
defmodule BinBin do

  def split_while(<<char, rest::binary>>, fun) do
    if fun.(char) do
      {tail, invalid} = split_while(rest, fun)
      {<<char>> <> tail, invalid}
    else
      {"", <<char, rest::binary>>}
    end
  end
end
