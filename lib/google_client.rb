require 'net/http'
require_relative './date_helpers'

class GoogleClient
  def self.fetch_weights(params)
    uri = weight_uri(params[:started_at])
    response = new_get_request(uri, params[:refresh_token])
    format_weights(response)

  rescue StandardError => e
    Rails.logger.debug e
    puts e
  end

  def self.fetch_activities(params)
    uri = activity_uri(params[:started_at])
    response = new_get_request(uri, params[:refresh_token])
    format_activities(response)

  rescue StandardError => e
    Rails.logger.debug e
    puts e
  end

  private

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
    auth_token = response['access_token']

    fail 'Auth token fetch failed. Refresh token expired?' if auth_token.nil?

    auth_token
  end

  def self.new_get_request(uri, refresh_token)
    auth_token = fetch_new_auth_token(refresh_token)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Get.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'
    req['Authorization'] = 'Bearer ' + auth_token

    response = http.request(req)
    if response.code == '200'
      return JSON.parse(response.body)
    else
      fail "Google Fit API error: #{response.body}"
    end
  end

  # FIXME: change to a map!
  def self.format_activities(data)
    id_map = {}
    activities = []
    data['point'].each do |record|
      google_id = record['value'][0]['intVal'].to_i
      # OPTIMIZE: the 'exclude' list should be defined elsewhere
      next if [0, 3, 4, 72, 109, 110, 111].include?(google_id)

      activity = {
        started_at: record['startTimeNanos'][0...-6], # rounds ns -> ms
        ended_at: record['endTimeNanos'][0...-6], # rounds ns -> ms
        # trims 'derived:com.google.activity.segment:'
        data_source: record['originDataSourceId'][36..-1],
        activity_type_id:
          id_map.fetch(google_id) do |google_id|
            id_map[google_id] = ActivityType.find_by(google_id: google_id).id
          end
      }

      activities << activity
    end
    activities
  end

  def self.format_weights(data)
    data['point'].map do |record|
      {
        time: record['startTimeNanos'][0...-6], # rounds ns --> ms
        rating: kg_to_lbs(record['value'][0]['fpVal'])
      }
    end
  end

  def self.weight_uri(started_at)
    started_at = started_at.to_s
    ended_at = DateHelpers.beginning_of_today.to_s
    fail "Start (#{started_at}) is after end (#{ended_at})." if started_at > ended_at

    uri = 'https://www.googleapis.com/fitness/v1/users/me/dataSources/raw:com.google.weight:com.google.android.apps.fitness:user_input/datasets/'
    uri += started_at + '000000-' + ended_at + '000000'

    URI(uri)
  end

  def self.activity_uri(started_at)
    started_at = started_at.to_s
    ended_at = DateHelpers.beginning_of_today.to_s
    fail "Start (#{started_at}) is after end (#{ended_at})." if started_at > ended_at

    uri = 'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.activity.segment:com.google.android.gms:merge_activity_segments/datasets/'
    uri += started_at + '000000-' + ended_at + '000000'

    URI(uri)
  end

  def self.kg_to_lbs(in_kg)
    (in_kg * 2.20462).round(2)
  end
end
