require 'net/http'
require 'json'

class GoogleClient

  # NOTE: this is currently unused because data recorded by Google Fit
  #       (instead of 3rd-party apps) is not saved in sessions.
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

  def self.fit_segments(refresh_token)
    auth_token = fetch_new_auth_token(refresh_token)
    return { error: 'internal error' } if auth_token.nil?

    uri = URI('https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req_body = {
      aggregateBy: [
        {
          dataSourceId: "derived:com.google.activity.segment:com.google.android.gms:merge_activity_segments"
        }
      ],
      startTimeMillis: 1441065600000, # FIXME: dynamically select start date
      endTimeMillis: 1444953600000, # FIXME: dynamically select end date
      bucketByActivitySegment: {
        minDurationMillis: 300000 # will only return activities 5+ minutes long
      }
    }
    req = Net::HTTP::Post.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'
    req['Authorization'] = 'Bearer ' + auth_token
    req.body = req_body.to_json

    response = http.request(req)
    response.code == '200' ? format_segments(JSON.parse(response.body)) : { error: 'internal error' }
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
    activities = []
    if data['bucket']
      data['bucket'].each do |record|
        unless [0, 3, 4].include?(record['activity']) # OPTIMIZE: the 'exclude' list should be defined elsewhere
          activity = {}
          activity[:start_time] = record['startTimeMillis'][0...-3].to_i # converts to seconds from milliseconds
          activity[:end_time] = record['endTimeMillis'][0...-3].to_i # converts to seconds from milliseconds
          activity[:data_source] = record['dataset'][0]['point'][0]['originDataSourceId'][36..-1] # trims 'derived:com.google.activity.segment:'
          activity[:activity_type_id] = record['activity'].to_i
          activities << activity
        end
      end
    end
    return activities
  end

end
