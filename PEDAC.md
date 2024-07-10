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
rule = { iprepmax: 2, t: 60 } # Struct?
rate_limiter = RateLimiter(rule)
rate_limiter.blocked(path)
#=> 3
counts = 2
blocks = 1

seen = { ip: TIMESTAMP }

2024-01-01T00:00:00+00:00,127.0.0.1,example1.onrender.com <--
2024-01-01T00:00:01+00:00,127.0.0.1,example2.onrender.com 
2024-01-01T00:01:02+00:00,127.0.0.1,example1.onrender.com <--
2024-01-01T00:01:03+00:00,127.0.0.1,example2.onrender.com
2024-01-01T00:01:04+00:00,127.0.0.1,example1.onrender.com
2024-01-01T00:02:04+00:00,127.0.0.1,example1.onrender.com
```

## Data Structures

- Hash
- CSV

## Algorithm

1. Deine the RateLimiter class to be instantiated w/ a rule
1. Define blocked
  - INstantiate a CSV object
  - Iterate over the rows of the CSV
    - 

