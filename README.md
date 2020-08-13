# Welcome to the Landdox Code Challenge :)

You have been invited to take the Landdox Elixir Code Challenge. We are not worried about the completion of the challenge. We just want to see an example of your work and then talk about your code. We care more about clarity and readablity than performance.

We expect you to spend around ~2 hours on the challenge. Feel free to spend more or less depending on your progress and your satisfaction with the results.

## First Steps

1. You should have received an email with your Landdox developer reviewer. Coordinate via email with them on the best time to review you project over a screen share. FYI there may be more than 1 Landdox employee joining the screen share.

2. Clone this Git repo. Do not fork it. We want to protect your work from prying eyes.

3. Create a new repo under your GitHub username. If you want to make it private, go ahead. You can then invite a Landdox developer as a collaborator. Keeping the repo public is also ok.

4. You are now ready to do the code challenge.

- If you do not have a GitHub account or wish to use BitBucket or GitLab, go right ahead.

## A bit about the app

* App was created using mix new.
* You can run the tests with `mix test`. You are encouraged to add more tests to account for more scenarios.
* You may use any date manipulation libraries such as Timex if you want

## Code Challenge

You will be coding a function that processes date ranges.

- The input is an unsorted list of date ranges. There may be duplicate, overlapping ranges etc.
- A date range is represented as a tuple of `{start_date, end_date}`. Each date is an erlang style date that looks like `{year, month, day}`.
  - year - Unabbreviated calendar year as an integer
  - month - 1..12
  - day - 1..31
- The output should return a list of date ranges that are cleaned up such that there are no duplicates, overlaps, or gaps, but the ranges should be as large as they can be given the constraints. 
  - Contiguous date ranges should not be combined (See the first test)
    - `{{2020, 1, 1}, {2020, 6, 30}}`, and `{{2020, 7, 1}, {2020, 12, 31}}` are contiguous because date ranges are inclusive.
  - An overlap should be resolved as in the second test.
    - `{{2020, 1, 1}, {2020, 12, 31}}`, and `{{2020, 7, 1}, {2020, 12, 31}}` share the end date, so the first range should get shortened to `{{2020, 1, 1}, {2020, 6, 30}}`
  - For any gap of time unaccounted for in the input, add that gap as a range in the output
  - The output should be ordered chronologically, with earlier date ranges first

# Good luck and have fun!
