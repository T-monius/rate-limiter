require 'minitest/autorun'
require_relative '../rate_limiter.rb'

class TestRateLimiter < Minitest::Test
  def test_blocked
    path = './data/requests_example.csv'
    rate_limiter = RateLimiter.new(1, 60)
    blocked = rate_limiter.blocked(path)

    assert_equal(3, blocked.size)
  end
end
