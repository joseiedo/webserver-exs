defmodule JsonParserTest do
  use ExUnit.Case

  test "should map simple json to map correctly" do
    input = "{\n\"foo\": 1\n}"
    result = JsonParser.parse(input)
    assert result == %{"foo" => "1"}
  end
end
