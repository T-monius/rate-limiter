require 'csv'
require 'time'


class RateLimiter
  Rule = Struct.new('Rule', :iprepmax, :time_frame)
  def initialize(rule)
    self.rule = rule
  end

  def blocked(path)
    seen = { ip: [] }
    blocked = []
    CSV.foreach(path, headers: true) do |current_request|
      requests_for_ip = seen[current_request['request_ip']] || []
      requests_for_ip << current_request and seen[current_request['request_ip']] = requests_for_ip
      next if requests_for_ip.size <= rule.iprepmax
      # Identify request that is beginning of time window
      anchor_request = requests_for_ip[-(rule.iprepmax + 1)]
      blocked << current_request unless outside_time_frame?(anchor_request, current_request)
    end
    blocked.size
  end

  def outside_time_frame?(anchor_request, current_request)
    anchor_time = Time.xmlschema(anchor_request['timestamp'])
    current_request_time = Time.xmlschema(current_request['timestamp'])
    current_request_time >= (anchor_time + rule.time_frame)
  end

  protected
  attr_accessor :rule
end
