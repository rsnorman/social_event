class FacebookClient
  CALLBACK_URL = 'http://www.socialevent.dev/apps/facebook/callback'

  def initialize(options = {})
    @client = Koala::Facebook::API.new(options[:access_token])
  end

  def authorize_url
    oauth.url_for_oauth_code(:permissions => "public_profile,user_photos,user_status,user_videos")
  end

  def get_access_token(code)
    @access_token = oauth.get_access_token(code)
  end

  def auth_params
    [:code]
  end

  def user_params_from_access_token(access_token)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object("me")
    picture = graph.get_picture(profile["id"])
    {
      :service_id => profile["id"],
      :service_type => "Facebook",
      :name => profile["name"],
      :profile_image_url => picture,
      :access_token => access_token
    }
  end

  private

  def oauth
    Koala::Facebook::OAuth.new("251292488401654", "4800a77bed1f41b373d178ae850673c1", CALLBACK_URL)
  end
end
