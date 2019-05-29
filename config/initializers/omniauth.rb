Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET'], scope: 'public_profile', info_fields: 'id,name,link'
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'userinfo.email, userinfo.profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50
    }
end