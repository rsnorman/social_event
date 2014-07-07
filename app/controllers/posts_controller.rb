class PostsController < ApplicationController
  def index
    @posts = []

    User.all.each do |user|
      if user.service_type == 'Instagram'
        client = Instagram.client(:access_token => user.access_token)
        @posts = @posts.concat(client.user_recent_media)
      else
        client = user.twitter_client
        @posts = @posts.concat(client.user_timeline)
      end
    end

    client = Instagram.client
    @posts = @posts.concat(client.tag_recent_media('NormGarvWedding'))

    client = TwitterClient.new.instance_variable_get("@client")
    @posts = @posts.concat(client.search('#NormGarvWedding').to_hash[:statuses].collect{|x| Hashie::Mash.new(x)})
  end
end
