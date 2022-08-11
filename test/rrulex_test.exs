defmodule RRulexTest do
  use ExUnit.Case
  doctest RRulex

  test "Convert basic attribute keys and values to struct" do
    assert RRulex.parse("FREQ=DAILY") == %RRulex{frequency: :daily}
    assert RRulex.parse("COUNT=2") == %RRulex{count: 2}
    assert RRulex.parse("INTERVAL=3") == %RRulex{interval: 3}
    assert RRulex.parse("BYSECOND=3") == %RRulex{by_second: [3]}
    assert RRulex.parse("BYSECOND=5,10,15") == %RRulex{by_second: [5, 10, 15]}
    assert RRulex.parse("BYMINUTE=1") == %RRulex{by_minute: [1]}
    assert RRulex.parse("BYHOUR=4") == %RRulex{by_hour: [4]}
    assert RRulex.parse("BYMONTH=5") == %RRulex{by_month: [:may]}
    assert RRulex.parse("BYMONTH=1,3,5") == %RRulex{by_month: [:january, :march, :may]}
    assert RRulex.parse("BYMONTHDAY=5") == %RRulex{by_month_day: [5]}
    assert RRulex.parse("BYMONTHDAY=-5") == %RRulex{by_month_day: [-5]}
    assert RRulex.parse("BYYEARDAY=5") == %RRulex{by_year_day: [5]}
    assert RRulex.parse("BYWEEKNO=5") == %RRulex{by_week_number: [5]}
    assert RRulex.parse("BYSETPOS=5") == %RRulex{by_set_pos: [5]}
    assert RRulex.parse("FREQ=DAILY;COUNT=5") == %RRulex{count: 5, frequency: :daily}
    assert RRulex.parse("BYDAY=MO") == %RRulex{by_day: [:monday]}
    assert RRulex.parse("BYDAY=MO,TU,TH") == %RRulex{by_day: [:monday, :tuesday, :thursday]}
    assert RRulex.parse("WKST=MO") == %RRulex{week_start: :monday}
  end
end
Footer
