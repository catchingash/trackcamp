require 'net/http'
require 'json'

class GoogleClient

  def self.fit_sessions
    uri = URI('https://www.googleapis.com/fitness/v1/users/me/sessions')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Get.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'
    req['Authorization'] = 'Bearer ' + fetch_new_auth_token

    response = http.request(req)

    JSON.parse(response.body)
  end

  # TODO: Store refresh token in the DB or in Redis
  # TODO: could cache the auth token
  def self.fetch_new_auth_token(refresh_token = ENV['REFRESH_TOKEN']) # FIXME: remove env variable # currently using to make testing easier
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

end
