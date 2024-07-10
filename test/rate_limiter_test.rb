require 'minitest/autorun'
require_relative '../rate_limiter.rb'

class TestRateLimiter < Minitest::Test
  def test_blocked_in_example_data
    path = './data/requests_example.csv'
    rate_limiter = RateLimiter.new(1, 60)
    blocked = rate_limiter.blocked(path)

    assert_equal(3, blocked)
  end

  def test_blocked_in_sample_data
    path = './data/requests_sample.csv'
    rate_limiter = RateLimiter.new(1, 60)
    blocked = rate_limiter.blocked(path)

    assert_equal(5, blocked)
  end

  def test_blocked_in_data
    path = './data/requests.csv'
    rate_limiter = RateLimiter.new(50, 60)
    blocked = rate_limiter.blocked(path)

    assert_equal(1446, blocked)
  end
end
