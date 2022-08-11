# RRulex
RRulex is an Elixir package that parses an RRULE from the [iCalendar RFC-2445](https://www.ietf.org/rfc/rfc2445.txt) and expands into a usable struct.

This Hex package is an extension of Austin Hammer's [RRulex](https://github.com/austinh/rrulex) that unfortunately never made it to distribution.

## Getting Started

```elixir
def deps do
  [
    {:rrulex, "~> 0.1.0"}
  ]
end
```

Here's a few simple examples:

```elixir
> use RRulex
> RRulex.parse("FREQ=DAILY")
%RRulex{
  by_day: [:friday],
  by_hour: [],
  by_minute: [],
  by_month: [],
  by_month_day: [],
  by_second: [],
  by_set_pos: [],
  by_week_number: [],
  by_year_day: [],
  count: 6,
  frequency: :weekly,
  interval: 2,
  until: nil,
  week_start: nil
}

> RRulex.parse("INTERVAL=2;FREQ=WEEKLY;BYDAY=FR;COUNT=6")
%RRulex{
  by_day: [:friday],
  by_hour: [],
  by_minute: [],
  by_month: [],
  by_month_day: [],
  by_second: [],
  by_set_pos: [],
  by_week_number: [],
  by_year_day: [],
  count: 6,
  frequency: :weekly,
  interval: 2,
  until: nil,
  week_start: nil
}
```

## License
This software is licensed under [the MIT license](https://github.com/jakecurreri/rrulex/blob/main/LICENSE.md)

