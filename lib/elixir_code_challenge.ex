defmodule ElixirCodeChallenge do
  @moduledoc """
  Given a list of date ranges, return a list of all possible non overlapping intervals covering the same range as the input
  an interval is represented as a tuple
  {start_date, end_date}
  where each element is an erlang date tuple
  {Year, Month, Day}
  Year - Unabbreviated calendar year as an integer
  Month - 1..12
  Day - 1..31
  """

  @type year() :: integer()
  @type month() :: integer()
  @type day() :: integer()

  @type erl_date :: {year(), month(), day()}
  @type erl_interval :: {erl_date(), erl_date()}

  @spec run(list(erl_interval())) :: list(erl_interval())
  def run(input) do
    input
    # Break a list of date ranges into a sorted list of unique dates
    |> take_uniq_dates()
    # Group list of dates into pairs
    |> Enum.chunk_every(2)
    # Fill unaccounted gaps of time with span date ranges
    |> backfill_date_gaps()
    # Convert Date.t() pairs back into expected tuple of date tuples
    |> Enum.map(&to_erl_interval/1)
  end

  @spec take_uniq_dates(list(erl_interval())) :: list(Date.t())
  defp take_uniq_dates(list_of_pairs),
    do:
      list_of_pairs
      |> Enum.flat_map(&Tuple.to_list/1)
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.map(&Timex.to_date/1)

  @spec backfill_date_gaps(list(date_pair)) :: list(date_pair)
        when date_pair: [Date.t()]
  # `reduce/3` allows using the previous range to inform the next one. Pushing
  # ranges onto the accumulator stack means that list needs to be flipped back
  # with `reverse/1` when we are finished.
  defp backfill_date_gaps(list_of_pairs),
    do:
      list_of_pairs
      |> Enum.reduce([], &build_date_intervals/2)
      |> Enum.reverse()

  @spec build_date_intervals(date_pair, list(date_pair)) :: list(date_pair)
        when date_pair: [Date.t()]
  # Empty Case: Begin list with first pair
  defp build_date_intervals(leading_date_pair, []),
    do: [leading_date_pair]

  # Odd Case: If there were an odd number of unique dates, then pair a start date
  # to the dangling end date
  defp build_date_intervals([trailing_date], acc) do
    [prior_interval | _t] = acc
    [_prior_start_date, prior_end_date] = prior_interval
    next_interval = [day_after(prior_end_date), trailing_date]

    [next_interval | acc]
  end

  # When adjacent ranges are not contiguous (i.e. more than 1 day difference), fill
  # the gap with a new range to make it so.
  defp build_date_intervals(date_pair, acc) do
    [prior_interval | _t] = acc
    [_prior_start_date, prior_end_date] = prior_interval
    [next_start_date, _next_end_date] = next_interval = date_pair

    maybe_gap_interval =
      if days_between(next_start_date, prior_end_date) > 1,
        do: [[day_after(prior_end_date), day_before(next_start_date)]],
        else: []

    [next_interval | maybe_gap_interval] ++ acc
  end

  # Timex helpers
  @spec day_before(Date.t()) :: Date.t()
  defp day_before(date), do: Timex.shift(date, days: -1)

  @spec day_after(Date.t()) :: Date.t()
  defp day_after(date), do: Timex.shift(date, days: 1)

  @spec days_between(Date.t(), Date.t()) :: integer()
  defp days_between(d0, d1), do: Timex.diff(d0, d1, :days)

  @spec to_erl_interval([Date.t()]) :: erl_interval()
  defp to_erl_interval(date_pair),
    do: date_pair |> Enum.map(&Timex.to_erl/1) |> List.to_tuple()
end
