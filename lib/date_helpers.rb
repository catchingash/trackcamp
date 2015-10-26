class DateHelpers
  def self.to_ms_since_epoch(time)
    (time.to_r * 1_000).round
  end

  def self.beginning_of_today
    to_ms_since_epoch(Time.current.beginning_of_day)
  end

  def self.thirty_one_days_ago
    to_ms_since_epoch(Time.current.beginning_of_day) - 2_678_000_000
  end

  def self.strptime_in_ms(string, strp_string)
    time = Time.strptime(string, strp_string)
    to_ms_since_epoch(time)
  end

  def self.parse_to_ms(string)
    time = Time.zone.parse(string)
    to_ms_since_epoch(time)
  end
end
