defmodule RRulex do
  alias RRulex.Parser

  @moduledoc """
  Parses an RRULE from the iCalendar RFC-2445 https://www.ietf.org/rfc/rfc2445.txt
  and expands into a usable struct.
  """

  defstruct frequency: nil,
            until: nil,
            count: nil,
            interval: nil,
            by_second: [],
            by_minute: [],
            by_hour: [],
            by_day: [],
            by_month: [],
            by_month_day: [],
            by_year_day: [],
            by_week_number: [],
            by_set_pos: [],
            week_start: nil

  def parse(rrule_string), do: Parser.parse(rrule_string)
end