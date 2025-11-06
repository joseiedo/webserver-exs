defmodule JsonParser do
  @tokens [
    open_bracket: ~r/^{/,
    open_list: ~r/^\[/,
    key: ~r/"([^"]+)"\s*:/,
    string: ~r/"([^"]*)",?/,
    number: ~r/[0-9]+/,
    closed_list: ~r/\]/,
    closed_bracket: ~r/}/,
    comma: ~r/,/
  ]

  def tokenize(data), do: tokenize(data, [])

  defp tokenize("", total), do: Enum.reverse(total)

  defp tokenize(data, total) do
    case tokenize_one(String.trim(data)) do
      nil -> Enum.reverse(total)
      {key, match, rest} -> tokenize(rest, [{key, match} | total])
    end
  end

  defp tokenize_one(data) do
    Enum.find_value(@tokens, fn {key, regex} ->
      case Regex.run(regex, data) do
        nil ->
          false

        [full | captures] ->
          result = List.first(captures) || full
          rest = String.trim_leading(String.slice(data, String.length(full)..-1//1))
          {key, result, rest}
      end
    end)
  end

  def parse(tokens), do: parse(tokens, nil, %{}) |> elem(1)

  defp parse([], _, json), do: {[], json}

  defp parse([{token_type, value} | rest], key, json) do
    case token_type do
      :open_bracket ->
        {remaining, inner} = parse(rest, nil, %{})
        updated = if key, do: Map.put(json, key, inner), else: inner
        parse(remaining, nil, updated)

      :closed_bracket ->
        {rest, json}

      :key ->
        parse(rest, String.to_atom(value), json)

      :number ->
        parse(rest, nil, Map.put(json, key, String.to_integer(value)))

      :string ->
        parse(rest, nil, Map.put(json, key, value))

      _ ->
        raise("Not implemented yet #{token_type}")
    end
  end
end
