defmodule JsonParser do
  def parse(data) do
    {result, _} =
      String.replace(data, "\n", "")
      |> String.split(":")
      |> Enum.map(fn x -> String.trim(x) end)
      |> Enum.reduce({%{}, ""}, fn current, {acc, key} ->
        if key == "" || String.starts_with?(current, "{\"") do
          nkey = String.replace_prefix(current, "{", "") |> String.replace("\"", "")
          {Map.put(acc, nkey, nil), nkey}
        else
          nVal = String.replace_suffix(current, "}", "") |> String.replace("\"", "")

          if String.ends_with?(current, "}") do
            {Map.put(acc, key, nVal), ""}
          else
            {Map.put(acc, key, current), key}
          end
        end
      end)

    result
  end
end
