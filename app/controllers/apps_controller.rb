class AppsController < ApplicationController
  def index
    @apps = [:instagram]
  end

  def auth
    redirect_to social_client.authorize_url
  end

  def callback
    auth_params = params.select { |key, value| social_client.auth_params.include?(key.to_sym) }
    access_token = social_client.get_access_token(*auth_params.values)
    @user = User.create(social_client.user_params_from_access_token(access_token))
  end

  private
  def social_client
    @social_client ||= SocialClient.create(params[:id])
  end
end
