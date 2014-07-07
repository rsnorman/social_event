class InstagramClient
  CALLBACK_URL = 'http://www.socialevent.dev/apps/instagram/callback'

  def initialize(options = {})
  end

  def authorize_url
    Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  def get_access_token(code)
    @access_token = Instagram.get_access_token(code, :redirect_uri => CALLBACK_URL)
  end

  def auth_params
    [:code]
  end

  def user_params_from_access_token(access_token)
    {
      :service_id => access_token.user.id,
      :service_type => "Instagram",
      :name => access_token.user.full_name,
      :profile_image_url => access_token.user.profile_picture,
      :username => access_token.user.username,
      :access_token => access_token.access_token
    }
  end
end
