require 'hashie'

class TwitterClient
  CALLBACK_URL = 'http://www.socialevent.dev/apps/twitter/callback'
  CONSUMER_KEY = 'rQokORM14BcTAfmHO2jdnEq3W'
  CONSUMER_SECRET = 'm7aAOCvByjXK3ZLnmTocxXQ2Wx2GCtIVZLNbJxW5jg5rosFxJ4'

  @@oauth_request_token_pairs = {}

  def initialize(options = {})
    @client = Twitter::REST::Client.new({
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET
    }.merge(options))
  end

  def authorize_url
    url = request_token.authorize_url
    @@oauth_request_token_pairs[url.split('oauth_token=').last] = {
      :token => request_token.token,
      :secret => request_token.secret
    }
    url
  end

  def get_access_token(oauth_token, oauth_verifier)
    auth_client.authorize(
      @@oauth_request_token_pairs[oauth_token][:token],
      @@oauth_request_token_pairs[oauth_token][:secret],
      :oauth_verifier => oauth_verifier
    )
  end

  def auth_params
    [:oauth_token, :oauth_verifier]
  end

  def user_params_from_access_token(access_token)
    @client.access_token = access_token.token
    @client.access_token_secret = access_token.secret
    user = @client.user

    {
      :service_id => user.id,
      :service_type => "Twitter",
      :name => user.name,
      :username => user.screen_name,
      :profile_image_url => user.profile_image_uri_https(:bigger).to_s,
      :access_token => access_token.token,
      :access_secret => access_token.secret
    }
  end

  private
  def auth_client
    @auth_client ||= TwitterOAuth::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET
    )
  end

  def request_token
   @request_token ||= auth_client.request_token(:oauth_callback => CALLBACK_URL)
  end
end
