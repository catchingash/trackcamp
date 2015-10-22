require 'net/http'

class GoogleClient
  # # NOTE: this is currently unused because data recorded by Google Fit
  # #       (instead of 3rd-party apps) is not saved in sessions.
  # def self.fit_sessions(refresh_token)
  #   auth_token = fetch_new_auth_token(refresh_token)
  #   return { error: 'internal error' } if auth_token.nil?

  #   uri = URI('https://www.googleapis.com/fitness/v1/users/me/sessions')
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  #   req = Net::HTTP::Get.new(uri.request_uri)
  #   req.content_type = 'application/json;encoding=utf-8'
  #   req['Authorization'] = 'Bearer ' + auth_token

  #   response = http.request(req)

  #   JSON.parse(response.body)
  # end

  def self.fit_segments(params)
    end_time = (Time.now.beginning_of_day.to_r * 1_000).round
    raise "Start (#{params[:start_time]}) is after end (#{end_time})." if params[:start_time] > end_time

    auth_token = fetch_new_auth_token(params[:refresh_token])
    raise 'Auth token fetch failed. Refresh token expired?' if auth_token.nil?

    uri = URI('https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req_body = {
      aggregateBy: [
        {
          dataSourceId: "derived:com.google.activity.segment:\
            com.google.android.gms:merge_activity_segments"
        }
      ],
      startTimeMillis: params[:start_time],
      endTimeMillis: end_time,
      bucketByActivitySegment: {
        minDurationMillis: 300_000 # will only return activities 5+ minutes long
      }
    }
    req = Net::HTTP::Post.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'
    req['Authorization'] = 'Bearer ' + auth_token
    req.body = req_body.to_json

    response = http.request(req)
    if response.code == '200'
      return format_segments(JSON.parse(response.body))
    else
      raise "Google Fit API error: #{response.body}"
    end

  rescue StandardError => e
    Rails.logger.debug e
    puts e
  end

  # OPTIMIZE: could cache the auth token
  def self.fetch_new_auth_token(refresh_token)
    uri = URI('https://www.googleapis.com/oauth2/v3/token')
    params = {
      refresh_token: refresh_token,
      client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      grant_type: 'refresh_token'
    }
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Post.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'

    response = http.request(req)
    response = JSON.parse(response.body)

    response['access_token']
  end

  def self.format_segments(data)
    id_map = {}
    activities = []
    if data['bucket']
      data['bucket'].each do |record|
        # OPTIMIZE: the 'exclude' list should be defined elsewhere
        next if [0, 3, 4, 72, 109, 110, 111].include?(record['activity'])

        activity = {}
        activity[:start_time] = record['startTimeMillis'].to_i
        activity[:end_time] = record['endTimeMillis'].to_i
        # trims 'derived:com.google.activity.segment:'
        activity[:data_source] = record['dataset'][0]['point'][0]['originDataSourceId'][36..-1]
        activity[:activity_type_id] = id_map.fetch(record['activity'].to_i) do |google_id|
          id_map[google_id] = ActivityType.find_by(googleID: google_id).id
        end
        activities << activity
      end
    end
    activities
  end
end
