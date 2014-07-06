class AppsController < ApplicationController
  def index
    @apps = [:instagram]
  end

  def auth
    redirect_to Instagram.authorize_url(:redirect_uri => IG_CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => IG_CALLBACK_URL)
    @user = User.create(:service_id => response.user.id,
                        :service_type => "Instagram",
                        :name => response.user.full_name,
                        :username => response.user.username,
                        :access_token => response.access_token,
                        :profile_image_url => response.user.profile_picture
    )
  end
end
