Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :google_oauth2, ENV["GOOGLE_OAUTH_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    {
      skip_jwt: true, # This makes me upset.
                      # However, this is required because sometimes the web token check fails
                      # and throws JWT::InvalidIatError, which is a problem.
                      # I'm not sure why it fails sometimes and not others.
                      # This appears to be an issue with the gem.
                      # See: zquestz/omniauth-google-oauth2#197
      scope: "email, \
        https://www.googleapis.com/auth/fitness.activity.read, \
        https://www.googleapis.com/auth/fitness.activity.write, \
        https://www.googleapis.com/auth/fitness.body.read, \
        https://www.googleapis.com/auth/fitness.body.write, \
        https://www.googleapis.com/auth/fitness.location.write",
      prompt: 'consent'
    }
end
