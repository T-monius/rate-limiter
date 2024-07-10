require 'csv'
require 'time'

class RateLimiter
  def initialize(max, t)
    self.iprepmax = max
    self.time_frame = t
  end

  def blocked(path)
    seen = { ip: [] }
    blocked = []
    CSV.foreach(path, headers: true) do |row|
      requests = seen[row['request_ip']] || []
      requests << row and seen[row['request_ip']] = requests
      next if requests.size <= iprepmax
      anchor_request = requests[-(iprepmax + 1)]
      anchor_time = Time.xmlschema(anchor_request['timestamp'])
      current_request_time = Time.xmlschema(row['timestamp'])
      blocked << row unless current_request_time >= (anchor_time + 60)
    end
    blocked.size
  end

  protected
  attr_accessor :iprepmax, :time_frame
end
