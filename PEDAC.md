# Render Rate Limiter

## Problem

Billion(s) requests
- CSV log

Rate limiting

__Part 1__

Rule
- ip
- time

Limit based on ip based on time (T)

__NOTE__

• A blocked request should still increment the rate limit counter and be considere in measurements for future requests
• Notice the boundary case of the final request. If a previous request is exactly T seconds before a given request, it should not be included in the request count when deciding whether to block.

## Examples/Test Cases

```ruby
rule = { iprepmax: 1, t: 60 } # Struct?
rate_limiter = RateLimiter(rule)
rate_limiter.blocked(path)
#=> 3
seen = { ip: [rq, rq1, rq2, rq3, rq4, rq5] }
# corresponds to ^
requests_for_ip = [rq, rq1, rq2, rq3, rq4, rq5]
#                      wswe
#                             c
blocked = [rq1, rq3, rq4]

2024-01-01T00:00:00+00:00,127.0.0.1,example1.onrender.com
2024-01-01T00:00:01+00:00,127.0.0.1,example2.onrender.com <-w
2024-01-01T00:01:02+00:00,127.0.0.1,example1.onrender.com <-c
2024-01-01T00:01:03+00:00,127.0.0.1,example2.onrender.com
2024-01-01T00:01:04+00:00,127.0.0.1,example1.onrender.com
2024-01-01T00:02:04+00:00,127.0.0.1,example1.onrender.com
```

## Data Structures

- Hash
- CSV

## Algorithm

1. Define the `RateLimiter` class to be instantiated w/ a rule (struct?)
1. Define blocked
  - Instantiate a CSV object
  - Instantiate a hash for ips with an array for requests
  - Instantiate an array `blocked`
  - Iterate over the rows of the CSV for current request
    - Access 'seen' for ip and add array for ip if `nil`
    - Add current request to `requests`
    - If `requests` is shorter than or equal to `iprepmax`, accept request (next/continue)
    - Instantiate a variable `anchor_request` `ipreqmax + 1` from end of `requests`
    - If request at `anchor_request` is younger than 60 seconds, add current request to `blocked`
1. Return `blocked` size

__Time comparison__

Determine if a given request (current) is within another (anchor)

1. Instantiate `Time` objects from a UTC strings
1. Current time >= Anchor time + 60 seconds
  - Determine how to add 60 seconds to a `Time` object
    + `t + 60` as `+` adds units of seconds
```sh
2024-01-01T00:00:00+00:00,127.0.0.1,example1.onrender.com
2024-01-01T00:00:01+00:00,127.0.0.1,example2.onrender.com
```
