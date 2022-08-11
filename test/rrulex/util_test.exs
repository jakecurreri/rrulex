defmodule RRulex.UtilTest do
  alias RRulex.Util
  use ExUnit.Case

  test "converts iCal RFC2445 date string to DateTime" do
    {:ok, date} = Util.to_date("19930721T133000")
    assert date.time_zone == "Etc/UTC"
    assert Timex.to_erl(date) == {{1993, 7, 21}, {13, 30, 0}}
  end
end