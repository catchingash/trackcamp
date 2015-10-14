require 'net/http'

class GoogleClient

  def fit_sessions(auth_token = ENV['TEMP_TOKEN']) # FIXME: remove env variable
    uri = URI('https://www.googleapis.com/fitness/v1/users/me/sessions')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Get.new(uri.request_uri)
    req.content_type = 'application/json;encoding=utf-8'
    req['Authorization'] = 'Bearer ' + auth_token

    response = http.request(req)
  end

end
