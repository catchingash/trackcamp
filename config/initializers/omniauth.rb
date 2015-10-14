Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV["GOOGLE_OAUTH_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    {
      scope: 'profile, https://www.googleapis.com/auth/fitness.activity.read, https://www.googleapis.com/auth/fitness.activity.write'
    }
end
