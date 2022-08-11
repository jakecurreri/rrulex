defmodule RRulex.Util do
  @moduledoc false

  def to_date(date_string, timezone \\ "Etc/UTC") do
    date_string =
      case String.last(date_string) do
        "Z" -> date_string
        _ -> date_string <> "Z"
      end

    Timex.parse(date_string <> timezone, "{YYYY}{0M}{0D}T{h24}{m}{s}Z{Zname}")
  end
end