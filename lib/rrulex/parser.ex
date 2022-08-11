defmodule RRulex.Parser do
  alias RRulex
  alias RRulex.{Util}

  @moduledoc """
  Parses an RRULE from the (iCalendar RFC-2445)[https://www.ietf.org/rfc/rfc2445.txt] a into RRulex%{}
  """

  @frequencies %{
    "SECONDLY" => :secondly,
    "MINUTELY" => :minutely,
    "HOURLY" => :hourly,
    "DAILY" => :daily,
    "WEEKLY" => :weekly,
    "MONTHLY" => :monthly,
    "YEARLY" => :yearly
  }

  @days %{
    "SU" => :sunday,
    "MO" => :monday,
    "TU" => :tuesday,
    "WE" => :wednesday,
    "TH" => :thursday,
    "FR" => :friday,
    "SA" => :saturday
  }

  @months [
    :january,
    :february,
    :march,
    :april,
    :may,
    :june,
    :july,
    :august,
    :september,
    :october,
    :november,
    :december
  ]

  @string_to_atoms %{
    "FREQ" => :frequency,
    "COUNT" => :count,
    "UNTIL" => :until,
    "INTERVAL" => :interval,
    "BYSECOND" => :by_second,
    "BYMINUTE" => :by_minute,
    "BYHOUR" => :by_hour,
    "BYMONTHDAY" => :by_month_day,
    "BYYEARDAY" => :by_year_day,
    "BYWEEKNO" => :by_week_number,
    "BYSETPOS" => :by_set_pos,
    "BYDAY" => :by_day,
    "BYMONTH" => :by_month,
    "WKST" => :week_start
  }

  @doc """
  Parses RRULE RFC-2445 string into a usable struct.
  ## Examples
      iex> RRulex.parse("FREQ=DAILY;COUNT=5")
      %RRulex{
         :frequency => :daily,
         :count     => 5
       }
  """
  def parse(rrule) do
    rrule
    |> String.split(";")
    |> Enum.reduce(%RRulex{}, fn rule, hash ->
      [key, value] = rule |> String.split("=")
      atomized_key = parse_attr_key(key)

      hash |> Map.put(atomized_key, parse_attr_value(atomized_key, value))
    end)
  end

  defp parse_value_as_list(value, map_fn) do
    value
    |> String.split(",")
    |> Enum.map(map_fn)
  end

  defp parse_attr_key(key) do
    case Map.fetch(@string_to_atoms, key) do
      {:ok, atom} ->
        atom
    end
  end

  defp parse_attr_value(:frequency, value) do
    case Map.fetch(@frequencies, value) do
      {:ok, freq} -> freq
      :error -> raise ArgumentError, message: "'#{value}' is not a valid frequency"
    end
  end

  defp parse_attr_value(:until, value) do
    out = Util.to_date(value, "Etc/UTC")

    case out do
      {:ok, date} -> date
      _ -> raise ArgumentError, message: "'#{value}' is not a valid date"
    end
  end

  defp parse_attr_value(:count, value) do
    value = String.to_integer(value)

    case value >= 1 do
      true -> value
      false -> raise ArgumentError, message: "'COUNT' must be greater than one"
    end
  end

  defp parse_attr_value(:interval, value) do
    value = String.to_integer(value)

    case value >= 1 do
      true -> value
      false -> raise ArgumentError, message: "'INTERVAL' must be greater than one"
    end
  end

  defp parse_attr_value(:by_second, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&(&1 >= 0 && &1 <= 59))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYSECOND' must be between 0 and 59"
    end
  end

  defp parse_attr_value(:by_minute, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&(&1 >= 0 && &1 <= 59))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYMINUTE' must be between 0 and 59"
    end
  end

  defp parse_attr_value(:by_hour, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&(&1 >= 0 && &1 <= 23))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYHOUR' must be between 0 and 23"
    end
  end

  defp parse_attr_value(:by_month_day, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&((&1 >= 1 && &1 <= 31) || (&1 <= 1 && &1 >= -31 && &1 != 0)))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYMONTHDAY' must be between 1 and 31 or -1 and -31"
    end
  end

  defp parse_attr_value(:by_year_day, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&((&1 >= 1 && &1 <= 366) || (&1 <= 1 && &1 >= -366 && &1 != 0)))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYYEARDAY' must be between 1 and 366 or -1 and -366"
    end
  end

  defp parse_attr_value(:by_week_number, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&((&1 >= 1 && &1 <= 53) || (&1 <= 1 && &1 >= -53 && &1 != 0)))

    case false in validation do
      false -> value
      true -> raise ArgumentError, message: "'BYWEEKNO' must be between 1 and 53 or -1 and -53"
    end
  end

  defp parse_attr_value(:by_set_pos, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&((&1 >= 1 && &1 <= 366) || (&1 <= 1 && &1 >= -366 && &1 != 0)))

    case false in validation do
      false ->
        value

      true ->
        raise ArgumentError,
          message: "'BYSETPOS' must be between 1 and 366 or -1 and -366 if it is set"
    end
  end

  defp parse_attr_value(:by_day, value) do
    # Upcase the values
    value =
      value
      |> parse_value_as_list(&String.upcase(&1))

    # Check to see if they're in the list of days
    validation =
      value
      |> Enum.map(&(&1 in Map.keys(@days)))

    # If they all are, then fetch the value for all of them and add them to the
    # valueerty.
    case false in validation do
      false -> Enum.map(value, &Map.fetch!(@days, &1))
      true -> raise ArgumentError, message: "'BYDAY' must have a valid day"
    end
  end

  defp parse_attr_value(:week_start, value) do
    value = String.upcase(value)

    case Map.fetch(@days, value) do
      {:ok, day} -> day
      _ -> raise ArgumentError, message: "'WKST' must have a valid day"
    end
  end

  defp parse_attr_value(:by_month, value) do
    value =
      value
      |> parse_value_as_list(&String.to_integer(&1))

    validation =
      value
      |> Enum.map(&(&1 >= 1 && &1 <= 12))

    case false in validation do
      false -> Enum.map(value, &Enum.at(@months, &1 - 1))
      true -> raise ArgumentError, message: "'BYMONTH' must be between 1 and 12 if it is set"
    end
  end

  defp parse_attr_value(key, _) do
    raise ArgumentError, message: "'#{key}' is not a valid attribute"
  end
end