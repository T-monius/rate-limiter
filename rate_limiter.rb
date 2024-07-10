require 'csv'

class RateLimiter
  def initialize(max, t)
    @iprepmax = max
    @time_frame = t
  end

  def blocked(path)
    csv = CSV.read(path, headers: true)
    seen = { ip: nil, count: 0, blocked: 0 }
    csv.foreach do |row|
      seen[:ip] = row['timestamp']
      if Date.new(seen[:ip]) < Date.new(row['timestamp'])
    end
  end
end

rate_limiter = RateLimiter.new(1, 60)
rate_limiter.blocked('./requests.csv')
