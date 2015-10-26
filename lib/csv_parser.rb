require 'csv'
require_relative './date_helpers'

class SleepBotCSVParser
  def self.create_sleep_records(user_id, file, utc_offset)
    CSV.foreach(file.path, headers: true, quote_char: "'", header_converters: :symbol, skip_blanks: true) do |row|
      create_sleep(user_id, row, utc_offset)
    end
  end

  def self.create_sleep(user_id, row, utc_offset)
    started_at = row[:date] + ' ' + row[:sleep_time] + ' ' + utc_offset
    started_at = DateHelpers.strptime_in_ms(started_at, '%m-%d-%Y %I:%M %P %z')

    ended_at = row[:date] + ' ' + row[:awake_time] + ' ' + utc_offset
    ended_at = DateHelpers.strptime_in_ms(ended_at, '%m-%d-%Y %I:%M %P %z')

    # Only 1 date is provided in the CSV from SleepBot. This is for awake_time.
    # If started_at and ended_at are on the same day (e.g. the user took a nap),
    # then there are no problems.
    # However, if this is not the case, then started_at needs to be
    # adjusted by 1 day.
    # Conversion: 86400000 ms == 1 day
    started_at = started_at < ended_at ? started_at : started_at - 86_400_000

    Sleep.create(user_id: user_id,
      started_at: started_at,
      ended_at: ended_at,
      rating: row[:rating])
  end
end
