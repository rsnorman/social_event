class User < ActiveRecord::Base
  attr_accessible :access_secret, :access_token, :name, :profile_image_url, :service_id, :service_type, :username

  def twitter_client
    SocialClient.new('twitter', {
      :access_token => self.access_token,
      :access_token_secret => self.access_secret
    })
  end
end

