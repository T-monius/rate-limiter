require 'minitest/autorun'
require_relative '../rate_limiter.rb'

class TestRateLimiter < Minitest::Test
  def test_blocked_in_example_data
    path = './data/requests_example.csv'
    rule = RateLimiter::Rule.new(1, 60)
    rate_limiter = RateLimiter.new(rule)
    blocked = rate_limiter.blocked(path)

    assert_equal(3, blocked)
  end

  def test_blocked_in_sample_data
    path = './data/requests_sample.csv'
    rule = RateLimiter::Rule.new(1, 60)
    rate_limiter = RateLimiter.new(rule)
    blocked = rate_limiter.blocked(path)

    assert_equal(5, blocked)
  end

  def test_blocked_in_data
    path = './data/requests.csv'
    rule = RateLimiter::Rule.new(50, 60)
    rate_limiter = RateLimiter.new(rule)
    blocked = rate_limiter.blocked(path)

    assert_equal(1446, blocked)
  end

  def test_within_time_frame
    timestamp =         '2024-01-01T00:00:00+00:00'
    another_timestamp = '2024-01-01T00:00:01+00:00'
    anchor_request = MockRequest.new(timestamp)
    current_request = MockRequest.new(another_timestamp)
    rule = RateLimiter::Rule.new(1, 60)
    rate_limiter = RateLimiter.new(rule)
    is_outside_time_frame = rate_limiter.outside_time_frame?(anchor_request, current_request)

    refute(is_outside_time_frame)
  end
  MockRequest = Struct.new('MockRequest', :timestamp)
end
