class PostsController < ApplicationController
  def index
    @posts = []

    User.all.each do |user|
      client = Instagram.client(:access_token => user.access_token)
      @posts = @posts.concat(client.user_recent_media)
    end

    client = Instagram.client
    @posts = @posts.concat(client.tag_recent_media('NormGarvWedding'))
    raise @posts.first.inspect
  end
end
